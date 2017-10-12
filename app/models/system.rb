class System < ApplicationRecord
	has_many :planets

	validates :name, presence: true
end
