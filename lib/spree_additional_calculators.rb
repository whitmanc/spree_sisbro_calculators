require 'spree_core'

module Spree
  class Engine < Rails::Engine

    config.autoload_paths += %W(#{config.root}/lib)

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc
     
     
    initializer "spree_active_shipping.register.calculators" do |app|
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/models/spree/calculator/**/*.rb")) do |c|
        Rails.env.production? ? require(c) : load(c)
      end

      app.config.spree.calculators.shipping_methods.concat(
        [Spree::Calculator::FedexTwoDay,
         Spree::Calculator::FedexGround,
         Spree::Calculator::FedexStandardOvernight,
         Spree::Calculator::UspsPriorityMail,
         Spree::Calculator::UspsFirstClass,
         Spree::Calculator::SuperSaver]
      )
    end 
  end
end