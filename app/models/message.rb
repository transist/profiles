class Message
  include Mongoid::Document
  
  belongs_to :profile
  belongs_to :provider
  has_and_belongs_to_many :brands
  has_and_belongs_to_many :mentions, :inverse_of => :profile_mentions
  
  field :data, type: Hash, :default => {}
end