class RankingPerGameController < ApplicationController

  def show
    games = GameQueries.all_finished_ordered_by_start_at
    user_rankings = TipQueries.all_by_user_id_and_game_ids(current_user.id,
                                                           games.map(&:id)).pluck(:ranking_place)

    @presenter = RankingPerGameShowPresenter.new(user_rankings, games)
  end
end
