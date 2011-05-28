module CachedDocument
  module Config
    class << self
      attr_accessor :configuration_file_path
      def configuration_file_path
        @configuration_file_path || "#{Rails.root if defined?(Rails)}/config/cached_document.yml"
      end
    end
  end
end