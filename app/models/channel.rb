class Channel < ActiveRecord::Base
  include KeyUtilities
  
  belongs_to :user
	has_many :feeds
	has_many :api_keys

  attr_readonly :created_at
  attr_protected :user_id, :last_entry_id

  after_create :set_initial_default_name
  before_validation :set_default_name
  after_destroy :delete_feeds, :delete_relations, :delete_group_relations
  validates :name, :presence => true, :on => :update

  DEVICE_TYPES=['Smartphone','Tablet','TV', 'Laptop', 'Desktop', 'Sensor','Arduino','RFID reader','RFID tag','Other']

  def add_write_api_key
    write_key = self.api_keys.new
    write_key.user = self.user
    write_key.write_flag = true
    write_key.api_key = generate_api_key
    write_key.save
  end

  def add_read_api_key
    read_key = self.api_keys.new
    read_key.user = self.user
    read_key.write_flag = false
    read_key.api_key = generate_api_key
    read_key.save
  end

  def field_label(field_number)
    self.attributes["field#{field_number}"]
  end
  
  def delete_feeds
    Feed.delete_all(["channel_id = ?", self.id])    
  end

  def delete_relations
    Relationship.delete_all(["guid_one = ? OR guid_two = ?", self.id,self.id]) if !Relationship.where(["guid_one = ? OR guid_two = ?", self.id,self.id]).blank?
  end

  def delete_group_relations
    GroupRelation.delete_all(["channel_id= ?", self.id]) if !GroupRelation.where(["channel_id= ?", self.id]).blank?
  end

  private

  def set_default_name    
    self.name = "#{I18n.t(:channel_default_name)} #{self.id}" if self.name.blank?
  end

  def set_initial_default_name
    update_attribute(:name, "#{I18n.t(:channel_default_name)} #{self.id}")
  end


end






# == Schema Information
#
# Table name: channels
#
#  id            :integer(11)      not null, primary key
#  user_id       :integer(11)
#  name          :string(255)
#  description   :string(255)
#  field1        :text
#  field2        :text
#  field3        :text
#  field4        :text
#  field5        :text
#  field6        :text
#  field7        :text
#  field8        :text
#  field9        :text
#  field10       :text
#  field11       :text
#  field12       :text
#  field13       :text
#  field14       :text
#  field15       :text
#  field16       :text
#  scale1        :integer(4)
#  scale2        :integer(4)
#  scale3        :integer(4)
#  scale4        :integer(4)
#  scale5        :integer(4)
#  scale6        :integer(4)
#  scale7        :integer(4)
#  scale8        :integer(4)
#  scale9        :integer(4)
#  scale10       :integer(4)
#  scale11       :integer(4)
#  scale12       :integer(4)
#  scale13       :integer(4)
#  scale14       :integer(4)
#  scale15       :integer(4)
#  scale16       :integer(4)
#  created_at    :datetime
#  updated_at    :datetime
#  elevation     :string(255)
#  last_entry_id :integer(4)
#  public_flag   :boolean(1)      default(true)
#  options1      :text
#  options2      :text
#  options3      :text
#  options4      :text
#  options5      :text
#  options6      :text
#  options7      :text
#  options8      :text
#  options9      :text
#  options10     :text
#  options11     :text
#  options12     :text
#  options13     :text
#  options14     :text
#  options15     :text
#  options16     :text
#  model         :text
#  brand         :text
#  device_type   :text
#  mobility_status :boolean(1)    default(false)
#  location      :integer(11)
#  location_name :text
#  location_type :integer(11)
#  oor_flag      :boolean(1)    default(true)
#  por_flag      :boolean(1)    default(true)
#  cwor_flag     :boolean(1)    default(true)
#  sor_flag      :boolean(1)    default(true)
#  clor_flag     :boolean(1)    default(true)
#  bt_mac_address   :text
#  wf_mac_address   :text
#

