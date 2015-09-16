class Systemuser < ActiveRecord::Base
  belongs_to :systemrole
  belongs_to :shell
  validates :name,
            presence: true
  validates :uid,
            presence: true
  validates :ensure,
            presence: true
  validates :comment,
            presence: true
  validates :systemrole_id,
            presence: true
  validates :shell_id,
            presence: true
  validates_uniqueness_of :uid
  validates_uniqueness_of :name
end
