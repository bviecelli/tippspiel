# -*- encoding : utf-8 -*-
require 'rails_helper'

describe Tournament, :type => :model do

  subject { Tournament }

  context '#started?' do

    context 'if first game is in the future' do
      it 'returns false' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now + 1.second)

        expect(subject.started?).to be false
      end
    end

    context 'if first game is not in the future' do
      it 'returns true' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now - 1.second)

        expect(subject.started?).to be true
      end
    end

  end

  context '#not_yet_started?' do

    context 'if first game is in the future' do
      it 'returns true' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now + 1.second)

        expect(subject.not_yet_started?).to be true
      end
    end

    context 'if first game is not in the future' do
      it 'returns false' do
        Timecop.freeze(Time.now)
        create(:game, :start_at => Time.now - 1.second)

        expect(subject.not_yet_started?).to be false
      end
    end

  end

  context '.finished?' do
    let!(:game1) {create :game}
    let!(:game2) {create :game}
    let!(:game3) {create :game}
    let!(:final) {create :final}

    context 'when final not finished' do
      it 'returns false' do
        expect(subject.finished?).to be false
      end
    end

    context 'when final exists' do
      it 'returns false' do
        final.destroy
        expect(subject.finished?).to be false
      end
    end

    context 'when final is finished' do
      it 'returns true' do
        final.update_column(:finished, true)
        expect(subject.finished?).to be true
      end
    end

  end

  context '.round_start_end_date_time' do

    let!(:game1) { create(:game, round: Game::GROUP,
                          group: Game::GROUP_A, start_at: Time.now + 1.day)}
    let!(:game2) { create(:game, round: Game::GROUP,
                          group: Game::GROUP_A, start_at: Time.now + 2.day)}
    let!(:game3) { create(:game, round: Game::GROUP,
                           group: Game::GROUP_B, start_at: Time.now - 2.day)}
    let!(:game4) { create(:game, round: Game::GROUP,
                           group: Game::GROUP_C, start_at: Time.now - 1.day)}


    it 'gets start and end date of group-round' do
      start_date_time, end_date_time = subject.round_start_end_date_time(Game::GROUP)
      expect(start_date_time).to be_equal_to_time(game3.start_at)
      expect(end_date_time).to be_equal_to_time(game2.start_at)
    end

    it 'gets start and end date of round with no games' do
      start_date_time, end_date_time = subject.round_start_end_date_time(Game::SEMIFINAL)
      expect(start_date_time).to be nil
      expect(end_date_time).to be nil
    end


  end

end