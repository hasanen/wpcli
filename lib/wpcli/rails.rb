module Wpcli
  def wpcli key
    load_apps if @apps.nil?
    @apps[key]
  end

  def wp_apps?
    load_apps if @apps.nil?
    !@apps.empty?
  end

  private

  def load_apps
    file = File.read("#{Rails.root}/config/wpcli.yml")
    config = YAML.load(file)

    @apps = {}
    if config.has_key?("apps") && !config["apps"].nil?
      config["apps"].each do |key, path|
        @apps[key.to_sym] = Client.new path
      end
    end
  end
end