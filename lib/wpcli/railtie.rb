module Wpcli
  class Railtie < Rails::Railtie
    initializer "Include wpcli in the controller" do
      ActiveSupport.on_load(:action_controller) do
        include Wpcli
      end
    end
end