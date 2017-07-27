require 'carrierwave/orm/activerecord'

class StationDatum < ApplicationRecord
	validates :station, presence: true, :uniqueness => {:case_sensitive => false}
	mount_uploader :data, StationDataUploader
	serialize :data, JSON # If you use SQLite, add this line.
end
