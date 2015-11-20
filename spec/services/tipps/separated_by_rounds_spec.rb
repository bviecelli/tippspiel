require 'rails_helper'

describe Tips::SeparatedByRounds do

  subject { Tips::SeparatedByRounds }

  context 'when no tips present?' do
    it 'returns empty array' do
      expect(subject.call(tips: [])).to eq([])
    end
  end

  context 'when games and tips present?' do

    let!(:game1_group_a) { create(:game, round: GROUP, group: GROUP_A)}
    let!(:game2_group_a) { create(:game, round: GROUP, group: GROUP_A)}

    let!(:game1_group_b) { create(:game, round: GROUP, group: GROUP_B)}
    let!(:game2_group_b) { create(:game, round: GROUP, group: GROUP_B)}

    let!(:game1_group_c) { create(:game, round: GROUP, group: GROUP_C)}
    let!(:game2_group_c) { create(:game, round: GROUP, group: GROUP_C)}

    # no games for group d - h  (groups e - h only if WM)
    # no games for round of 16 (only WM)

    let!(:game1_quarter) { create(:game, round: QUARTERFINAL, group: nil)}
    let!(:game2_quarter) { create(:game, round: QUARTERFINAL, group: nil)}

    let!(:game1_sf) { create(:game, round: SEMIFINAL, group: nil)}
    let!(:game2_sf) { create(:game, round: SEMIFINAL, group: nil)}

    # no game for place 3 (only WM)

    let!(:game_f) { create(:game, round: FINAL, group: nil)}


    let!(:tip1_group_a) { create(:tip, game: game1_group_a)}
    let!(:tip2_group_a) { create(:tip, game: game2_group_a)}

    let!(:tip1_group_b) { create(:tip, game: game1_group_b)}
    let!(:tip2_group_b) { create(:tip, game: game2_group_b)}

    let!(:tip1_group_c) { create(:tip, game: game1_group_c)}
    let!(:tip2_group_c) { create(:tip, game: game2_group_c)}

    # no tips for group d - h  (groups e - h only if WM)
    # no tips for round of 16 (only WM)

    let!(:tip1_quarter) { create(:tip, game: game1_quarter)}
    let!(:tip2_quarter) { create(:tip, game: game2_quarter)}

    let!(:tip1_sf) { create(:tip, game: game1_sf)}
    let!(:tip2_sf) { create(:tip, game: game2_sf)}

    # no game for place 3 (only WM)

    let!(:tip_f) { create(:tip, game: game_f)}


    it 'returns games seperated by rounds' do
      expect(Game.count).to eq(11)
      expect(Tip.count).to eq(11)

      if IS_WM
        expected = [
            [1, {'group_a' => [tip1_group_a, tip2_group_a]}],
            [2, {'group_b' => [tip1_group_b, tip2_group_b]}],
            [3, {'group_c' => [tip1_group_c, tip2_group_c]}],
            [4, {'group_d' => []}],
            [5, {'group_e' => []}],
            [6, {'group_f' => []}],
            [7, {'group_g' => []}],
            [8, {'group_h' => []}],
            [9, {'roundof16' => []}],
            [10, {'quarterfinal' => [tip1_quarter, tip2_quarter]}],
            [11, {'semifinal' => [tip1_sf, tip2_sf]}],
            [12, {'place3' => []}],
            [13, {'final' => [tip_f]}]
        ]
      elsif IS_EM
        expected = [
            [1, {'group_a' => [tip1_group_a, tip2_group_a]}],
            [2, {'group_b' => [tip1_group_b, tip2_group_b]}],
            [3, {'group_c' => [tip1_group_c, tip2_group_c]}],
            [4, {'group_d' => []}],
            [5, {'quarterfinal' => [tip1_quarter, tip2_quarter]}],
            [6, {'semifinal' => [tip1_sf, tip2_sf]}],
            [7, {'final' => [tip_f]}]
        ]
      end


      expect(subject.call(tips: Tip.all)).to eq(expected)
    end

  end
end