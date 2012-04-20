class Notice < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :user

  validates_presence_of :text
  validates_presence_of :user

  default_scope order("created_at desc")

end
