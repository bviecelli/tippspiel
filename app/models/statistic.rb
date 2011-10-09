class Statistic < ActiveRecord::Base

  belongs_to :user
  belongs_to :day

  validates_presence_of :user
  validates_presence_of :day
  validates_presence_of :position

end