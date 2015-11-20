# -*- encoding : utf-8 -*-
module HelpHelper

  def write_round_infos
    rounds = ROUNDS
    if rounds.present?
      haml_tag :ul, :class => 'hilfe' do
        rounds.each do |round|
          start_date_time, end_date_time = Tournament.round_start_end_date_time(round)
          start_date = start_date_time.present? ? l(start_date_time, :format => :only_date) : '-'
          end_date   = end_date_time.present? ? l(end_date_time, :format => :only_date) : '-'
          haml_tag :li, "#{start_date} - #{end_date}: #{t(round, :scope => 'round')}"
        end
      end
    end
  end
end
