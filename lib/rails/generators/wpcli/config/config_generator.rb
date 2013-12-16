module Wpcli
  class ConfigGenerator < Rails::Generators::Base
    desc 'Generates example config for your rails app'

    def self.source_root
       @_wpcli_source_root ||= File.expand_path("../templates", __FILE__)
     end

     def create_config_file
       template 'config_example.yml', File.join('config', 'wpcli.yml')
     end
    end
end