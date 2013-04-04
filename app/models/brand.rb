class Brand
  include Mongoid::Document
  has_and_belongs_to_many :messages
  has_many :profiles
  
  field :name, type: String
  field :uid, type: String
  field :screen_name, type: String
  
  field :slug, type: String
  field :matchers, type: Array, :default => []
  
  before_create :generate_slug
  
  def generate_slug
    self.slug = self.name.parameterize
    self.matchers << self.name.downcase
  end
end