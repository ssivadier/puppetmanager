class Shell < ActiveRecord::Base
  has_many :systemusers
  validates :name,
            presence: true
end
