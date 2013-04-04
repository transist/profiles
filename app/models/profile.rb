class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  has_many :messages
  has_many :graphs
  belongs_to :provider
  belongs_to :brand
  has_and_belongs_to_many :profile_mentions, :inverse_of => :mentions, :class_name => 'Message'
  
  field :uid, type: String
  field :screen_name, type: String
  field :data, type: Hash, :default => {}
  field :properties, type: Hash, :default => {:brand => {}, :political => {}, :demographics => {}}
  field :timestamps, type: Hash, :default => {}
  field :priority, type: Integer, :default => 1
  field :automated, type: Integer, :default => 0
  field :frequency, type: Float, :default => 0.0
  field :first_post_on, type: DateTime
  
  def create_new_graphs
    update_profile_data
    ['inbound', 'outbound'].each do |dir|
      Graph.create(:profile_id => self.id, :direction => dir, :provider_id => self.provider_id)
    end
  end
  
  def update_profile_data
    self.provider.download_profile(:uid => self.uid)
  end
  
  def following
    Graph.where(:profile_id => self.id, :direction => 'inbound').last
  end
  
  def followers
    Graph.where(:profile_id => self.id, :direction => 'outbound').last
  end
  
  def followed_by(profile)
    Graph.where(:profile_id => self.id, :direction => 'outbound').last.profiles.push(profile)
  end
  
  def follow(profile)
    Graph.where(:profile_id => self.id, :direction => 'inbound').last.profiles.push(profile)
  end
end