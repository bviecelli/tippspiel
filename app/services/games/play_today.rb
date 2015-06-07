# -*- encoding : utf-8 -*-
module Games
  class PlayToday < BaseService

    def call
      play_today
    end

    private

    # Es werden die Spiele einschliesslich 00:00 bis 24:00
    # des Tages geliefert
    def play_today
      t = Time.now.midnight
      ::Game.where(:start_at => [t..t+1.day])
    end

  end
end