# -*- encoding : utf-8 -*-
# berechnet für alle Nutzer die Punkte
# calculate_user_points
# calculate_all_user_tipp_points
#

module CalculatePoints

  MAX_POINTS_PRO_TIPP  = 8
  POINTS_CORRECT_TREND = 3
  EXTRA_POINT_GOALS    = 2
  EXTRA_POINT          = 1
  CHAMPION_TIPP_POINTS = 8

  def calculate_user_points
    users = User.active
    if users.present?
      users.each do |user|
        total_points  = Tipp.where(:user_id => user.id).sum(:tipp_punkte)
        total_points  = 0 unless total_points.present?

        champion_tipp_points = 0
        champion_team_id     = Game.tournament_champion_team.present? ? Game.tournament_champion_team.id : nil
        if Game.tournament_finished? &&
                user.championtipp_team_id.present? &&
                user.championtipp_team_id == champion_team_id
          champion_tipp_points = CHAMPION_TIPP_POINTS
          total_points = total_points + champion_tipp_points
        end

        count_8points = Tipp.where({:user_id => user.id, :tipp_punkte => 8}).count
        count_5points = Tipp.where({:user_id => user.id, :tipp_punkte => 5}).count
        count_4points = Tipp.where({:user_id => user.id, :tipp_punkte => 4}).count
        count_3points = Tipp.where({:user_id => user.id, :tipp_punkte => 3}).count
        count_0points = Tipp.where({:user_id => user.id, :tipp_punkte => 0}).count

        user.update_columns({:points => total_points,
                                :championtipppoints => champion_tipp_points,
                                :count8points => count_8points,
                                :count5points => count_5points,
                                :count4points => count_4points,
                                :count3points => count_3points,
                                :count0points => count_0points,
                               })
        Rails.logger.info("CALCULATE_USER_POINTS: #{user.name} - totalpoints: #{total_points}") if Rails.logger.present?
      end
    end
  end

  def calculate_all_user_tipp_points
    games = Game.all
    games.each do |game|
      if game.finished?
        update_all_tipp_points_for(game)
      end
    end

  end

  def update_all_tipp_points_for(game)
    if game.present?
      game_winner = game.winner

      if game_winner.present?
        Rails.logger.info("UPDATE_ALL_TIPP_POINTS: for game-id #{game.id}") if Rails.logger.present?
        tipps = Tipp.where(:game_id => game.id)
        if tipps.present?
          tipps.each do |tipp|
            points = 0
            if tipp.complete_fill?
              points = calculate_tipp_points(game_winner, game.team1_goals, game.team2_goals, tipp.team1_goals, tipp.team2_goals)
            end
            tipp.update_column(:tipp_punkte, points)
            Rails.logger.info("UPDATE_ALL_TIPP_POINTS:   tipp-id #{tipp.id} has #{points} points") if Rails.logger.present?
          end
        end
      end
    end
  end

  def calculate_tipp_points(game_winner, game_team1_goals, game_team2_goals, tipp_team1_goals, tipp_team2_goals)
    points = 0
    if (Game::UNENTSCHIEDEN == game_winner && tipp_team1_goals == tipp_team2_goals) ||
            (Game::TEAM1_WIN == game_winner && tipp_team1_goals > tipp_team2_goals) ||
            (Game::TEAM2_WIN == game_winner && tipp_team1_goals < tipp_team2_goals)
      points = points + POINTS_CORRECT_TREND
    end

    # nur wenn die Spieltendenz stimmt, gibt es auch die Punkte auf die richtige Toranzahl pro Team
    if POINTS_CORRECT_TREND == points
      points = points + EXTRA_POINT_GOALS if game_team1_goals == tipp_team1_goals
      points = points + EXTRA_POINT_GOALS if game_team2_goals == tipp_team2_goals
    end

    # 1 Punkt fuer richtige Tordifferenz
    goal_diff = tipp_team1_goals - tipp_team2_goals
    game_diff = game_team1_goals - game_team2_goals
    points = points + EXTRA_POINT if goal_diff == game_diff

    points
  end

end
