class GroupRelation < ActiveRecord::Base
  belongs_to :group
  belongs_to :channel
end
