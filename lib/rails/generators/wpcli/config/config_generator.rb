module WPCLI
  module Generators
    class ConfigGenerator < Rails::Generators::Base
      desc 'Generates config example for your rails app'

      def self.source_root
         @_wpcli_source_root ||= File.expand_path("../templates", __FILE__)
       end

       def create_config_file
         template 'wpcli.yml', File.join('config', 'wpcli.yml')
       end
    end
  end
end