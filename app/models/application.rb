class Application
  include Mongoid::Document
  has_many :authentications
  belongs_to :provider
  field :domain, type: String
  field :key, type: String
  field :secret, type: String
  field :redirect_uri, type: String
end