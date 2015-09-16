class Systemrole < ActiveRecord::Base
  has_many :systemusers
  has_and_belongs_to_many :optgroups
  accepts_nested_attributes_for :optgroups, allow_destroy: true,
                                reject_if: proc { |attributes| attributes['name'].blank? }
  validates :name,
            presence: true
  validates :gid,
            presence: true
  validates_uniqueness_of :gid
  validates_uniqueness_of :name
end
