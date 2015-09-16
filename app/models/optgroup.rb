class Optgroup < ActiveRecord::Base
  has_and_belongs_to_many :systemroles
  validates :name,
            presence: true
end
