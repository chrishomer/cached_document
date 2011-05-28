module CachedDocument
  class Document
    require "active_model"
    include ActiveModel::Serialization
    
    def self.setup(m)
      class << self
        attr_accessor :cache_store, :settings
      end
      self.settings = m.cached_document_settings[m.to_s.downcase]
      cs = self.settings["cache_store"]
      case cs["type"]
      when "memcache"
        require "MemCache"
        host = cs["host"]
        port = cs["port"]
        self.cache_store = MemCache.new("#{host}:#{port}")
      when "rails"
        self.cache_store = Rails.cache
      when "redis"
        raise "NOT IMPLEMENTED YET"
      end
    end
    
    def self.setup_flat_attributes(m)
      class << self
        attr_accessor :attributes
      end
      self.attributes = self.settings["attributes"]
      
      self.attributes.each do |at|
        attr_accessor at
      end
    end
    
    def self.new(o,variation = "default")
      cached_obj = self.cache_store.get(self.cache_key(o,variation))
      return Marshal.load( cached_obj ) if cached_obj
      
      cached_obj = super
      self.cache_store.set(self.cache_key(o,variation),Marshal.dump(cached_obj))
      cached_obj
    end
    
    def initialize(o,variation = "default")
      super
      @obj = o
      
      load_fresh_data
      
      remove_instance_variable(:@obj)
      self
    end
    
    def cache_store
      self.class.cache_store
    end
    
    def attributes
      self.class.attributes
    end
    
    def settings
      self.class.settings
    end
    
    def cache_key
      self.class.cache_key
    end
    
    def self.cache_key(obj,variation = "default")
      ck_parts = ["CachedDocument"]
      ck_parts << obj.class.to_s
      ck_parts << variation
      ck_parts |= self.settings["cache_key"].collect{|msg| obj.send(msg) }
      ck_parts.join("-")
    end
    
    protected 
      def load_fresh_data
        self.attributes.each do |fa|
          if @obj.respond_to?("cached_#{fa}")
            self.send(fa.to_s + "=",@obj.send("cached_#{fa}"))
          elsif @obj.respond_to?(fa)
            self.send(fa.to_s + "=",@obj.send(fa))
          end
        end
      end
    
  end
end