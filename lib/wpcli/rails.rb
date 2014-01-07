module Wpcli
  def wpcli key
    load_apps if @apps.nil?
    @apps[key]
  end

  private

  def load_apps
    file = File.read("#{Rails.root}/config/wpcli.yml")
    config = YAML.load(file)

    @apps = {}
    config["apps"].each do |key, path|
      @apps[key.to_sym] = Client.new path
    end
  end
end