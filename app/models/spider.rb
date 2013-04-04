class Spider
  attr_accessor :url, :user_agent, :html, :page, :cache
  
  def initialize(options)
    self.url = options[:url]
    self.user_agent = (options[:user_agent] || "Echidna")
  end
  
  def perform
    c = Curl::Easy.new(self.url) do|curl|
      curl.follow_location = true
    end
    c.perform
    self.html = c.body_str
    self
  end
  
  def save
    p = Page.where(:url => self.url).first_or_create
    p.html = self.html
    p.save
    p
  end
end