require "yaml"
module CachedDocument
  # Your code goes here...
  require "cached_document/config"
  require "cached_document/version"
  require "cached_document/document"
  
  def self.included(the_model)
    class << the_model
      attr_accessor :cached_document_settings
    end
    
    the_model.cached_document_settings = options
    
    #configure cache
    the_model::Document.setup(the_model)
    
    the_model::Document.setup_flat_attributes(the_model)
  end
  
  def self.options
    path = Config.configuration_file_path
    yml_hsh = YAML.load_file(path)
    yml_hsh
  end
  
  def cached(variation = "default")
    @cached ||= {}
    @cached[variation] ||= Document.new(self,variation)
  end
  
end
