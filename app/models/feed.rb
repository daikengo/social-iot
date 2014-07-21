class Feed < ActiveRecord::Base
	belongs_to :channel

  self.include_root_in_json = false
  
  #attr_readonly :created_at
  attr_protected :channel_id

end





# == Schema Information
#
# Table name: feeds
#
#  id         :integer(4)      not null, primary key
#  channel_id :integer(4)
#  raw_data   :text
#  field1     :text
#  field2     :text
#  field3     :text
#  field4     :text
#  field5     :text
#  field6     :text
#  field7     :text
#  field8     :text
#  field9     :text
#  field10    :text
#  field11    :text
#  field12    :text
#  field13    :text
#  field14    :text
#  field15    :text
#  field16    :text
#  created_at :datetime
#  updated_at :datetime
#  entry_id   :integer(4)
#

