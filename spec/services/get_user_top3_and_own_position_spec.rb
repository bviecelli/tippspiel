# -*- encoding : utf-8 -*-
require 'rails_helper'

describe GetUserTop3AndOwnPosition do

  it 'should get top3_positions_and_own_position' do
    User.delete_all # fixture users delete
    result = GetUserTop3AndOwnPosition.call(:user_id => nil)
    user_top3_ranking_hash = result.user_top3_ranking_hash
    own_position = result.own_position

    expect(own_position).to eq(nil)
    expect(user_top3_ranking_hash).to eq({})

    # 10 User anlegen, alle auf der selben Platzierung
    user_size = 10
    points    = 13
    user_size.times do |index|
      FactoryGirl.create(:user,
                        :lastname => "user#{index}",
                        :points => points,
                        :confirmed_at => Time.now - 5.minutes)
    end

    last_db_user = User.last
    result = GetUserTop3AndOwnPosition.call(:user_id => last_db_user.id)
    user_top3_ranking_hash = result.user_top3_ranking_hash
    own_position = result.own_position

    expect(own_position).to eq(1)
    expect(user_top3_ranking_hash.size).to eq(1)
    expect(user_top3_ranking_hash[1].size).to eq(User.count)

    result = GetUserTop3AndOwnPosition.call(:user_id => nil)
    user_top3_ranking_hash = result.user_top3_ranking_hash
    own_position = result.own_position

    expect(own_position).to eq(nil)
    expect(user_top3_ranking_hash.size).to eq(1)
    expect(user_top3_ranking_hash[1].size).to eq(User.count)
  end

end

