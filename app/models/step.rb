class Step < ActiveRecord::Base
  belongs_to :funnel
  
  serialize :meta, Hash
  serialize :internal_links, Hash
  serialize :external_links, Array
  
  before_save :populate_fields
  
  
  def populate_fields
    metainspector = MetaInspector.new(self.url)
    
    self.title = metainspector.title
    self.description = metainspector.description
    self.meta = metainspector.meta
    self.internal_links = generate_internal_links(metainspector.internal_links)
    self.external_links = metainspector.external_links
  end
    
  def generate_internal_links(internal_links)
    links = {}
    
    internal_links.each do |link|
      parser = Addressable::URI.parse(link)
      
      if links[parser.path] == nil
        links[parser.path] = 1
      else
        links[parser.path] += 1 
      end
    end
    
    links
  end
  
  def host
    URI.parse(self.url).host
  end
    
  def path
    URI.parse(self.url).path
  end
  
end
