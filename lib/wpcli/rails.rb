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
    p config
    config["config"]["apps"].each do |key, path|
      p "#{key} - #{path}"
      @apps[key] = Client.new path
    end
  end
end