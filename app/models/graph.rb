class Graph
  include Mongoid::Document
  include Mongoid::Timestamps
  belongs_to :profile
  belongs_to :provider
  field :direction
  has_and_belongs_to_many :profiles, inverse_of: nil
end