# -*- encoding : utf-8 -*-
class RankingController < ApplicationController

  def index
    @user_count        = User.active.count
    @user_ranking_hash = User.prepare_user_ranking
  end

  def hall_of_fame

  end

  def user_statistic
     # FIXME soeren 09.05.12 #24 todo Daten laden
    # Statistic Model
    # TODO soeren 09.05.12 wann werden die Daten gespeichert
    render :layout => false
  end

end
