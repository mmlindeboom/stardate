module Permalink
  def self.included(base)    
    base.before_validation :create_unique_permalink, :on=>:create
  end
  
  def create_unique_permalink
    return unless name
    
    safe_to_use = false
    count = 1
    while !safe_to_use
      if count == 1
        try_to_use = name.parameterize
      else
        try_to_use = name.parameterize + "-#{count}"
      end
      
      if self.class.where(permalink: try_to_use).count > 0
        count = count + 1
      else
        safe_to_use = true
      end
    end
    self.permalink = try_to_use 
  end
  
  def to_param
    permalink
  end
end