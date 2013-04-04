class Authentication
  include Mongoid::Document
  belongs_to :application
  field :token, type: String
  field :secret, type: String
end