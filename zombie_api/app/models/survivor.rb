class Survivor < ApplicationRecord
	has_one :inventory

	accepts_nested_attributes_for :inventory
end
