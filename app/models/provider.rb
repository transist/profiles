class Provider
  include Mongoid::Document
  field :name, type: String
  has_many :profiles
  has_many :messages
  has_many :graphs
  has_many :applications
end