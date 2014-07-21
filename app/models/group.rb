class Group < ActiveRecord::Base
  has_many :group_relations

  after_destroy :delete_group_relations

  def delete_group_relations
    GroupRelation.delete_all(["group_id = ?", self.if])
  end

  def as_json(options={})
    super(:only => [:id, :place_id, :tag1, :tag2, :tag3])
  end
end
