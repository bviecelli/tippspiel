module Users
  class UpdateRankingPerGame < UserBaseService

    def call
      finished_games = ::GameQueries.all_finished_ordered_by_start_at_with_preload_tips
      all_8point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, 8)
      all_5point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, 5)
      all_4point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, 4)
      all_3point_tips = ::TipQueries.all_by_games_and_tip_points(finished_games, 3)
      used_game_ids = []

      finished_games.each do |game|
        tips_for_game = game.tips
        used_game_ids << game.id

        ordered_user_id_and_ranking_comparison_value = get_ordered_user_id_and_ranking_comparison_value(all_8point_tips,
                                                                                                        all_5point_tips,
                                                                                                        all_4point_tips,
                                                                                                        all_3point_tips,
                                                                                                        used_game_ids)

        result_for_this_game     = {}
        place                    = 1
        user_count_on_same_place = 1
        last_ranking_comparison_value = nil

        ordered_user_id_and_ranking_comparison_value.each do |user_id, ranking_comparison_value|
          if last_ranking_comparison_value.nil?
            # erste User
            result_for_this_game[place] = [user_id]
          else
            if last_ranking_comparison_value > ranking_comparison_value
              place = place + user_count_on_same_place
              result_for_this_game[place] = [user_id]
              user_count_on_same_place = 1
            elsif last_ranking_comparison_value == ranking_comparison_value
              user_id_on_same_place = result_for_this_game[place]
              result_for_this_game[place] = user_id_on_same_place + [user_id]
              user_count_on_same_place = user_count_on_same_place + 1
            else
              # no else
            end
          end
          last_ranking_comparison_value = ranking_comparison_value
        end

        mass_updating_tips(result_for_this_game, tips_for_game)
      end

      true
    end

    private

    def get_ordered_user_id_and_ranking_comparison_value(all_8point_tips, all_5point_tips, all_4point_tips, all_3point_tips, used_game_ids)
      user_id_and_sum_tip_points = TipQueries.sum_tip_points_group_by_user_id_by_game_ids(used_game_ids)

      user_id_and_ranking_comparison_value = user_id_and_sum_tip_points.map { |user_id, sum_tip_points|
        count_8points = all_8point_tips.select { |tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id }.size
        count_5points = all_5point_tips.select { |tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id }.size
        count_4points = all_4point_tips.select { |tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id }.size
        count_3points = all_3point_tips.select { |tip| used_game_ids.include?(tip.game_id) && tip.user_id == user_id }.size

        [user_id, ranking_comparison_value(sum_tip_points, count_8points, count_5points, count_4points, count_3points).to_i]
      }

      ordered_user_id_and_ranking_comparison_value = user_id_and_ranking_comparison_value.sort_by { |_, tip_points| tip_points }.reverse
    end

    def mass_updating_tips(result_for_this_game, tips_for_game)
      sql_when_values = []
      sql_where_all_ids = []

      result_for_this_game.each do |ranking_place, user_ids|
        tip_ids = tips_for_game.select { |tip| tip.id if user_ids.include?(tip.user_id) }.map(&:id)

        tip_ids.each do |tip_id|
          sql_when_values << "WHEN id = #{tip_id} THEN #{ranking_place}"
        end
        sql_where_all_ids = sql_where_all_ids + tip_ids
      end

      sql = "UPDATE tips SET ranking_place = CASE #{sql_when_values.join(' ')} END WHERE id IN (#{sql_where_all_ids.join(',')})"
      ::Tip.connection.execute(sql)
    end
  end
end