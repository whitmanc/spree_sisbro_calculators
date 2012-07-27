module Spree
  class Calculator::UspsPriorityMail < Calculator
    preference :default_item_weight, :decimal, :default => 0
    
    # If we wanted to get input from the user for compute()
    #preference :amount, :decimal, :default => 0

    def self.description
      "USPS Priority Mail"
    end

    def compute(object)
      line_items = object_to_line_items(object)
      return nil if line_items.nil?

      total_weight = get_total_weight(line_items)
      
      if total_weight >= 13 and total_weight < 16
        7.0
      elsif total_weight >= 16 and total_weight < 24
        11.0
      else
        nil
      end 
    end
    
    protected
      # get total weight of the order
      def get_total_weight(line_items)
        line_items.map do |li|
          # use default item weight if the weight is not defined for a product
          item_weight = li.variant.weight.nil? ? self.preferred_default_item_weight : li.variant.weight
          item_weight * li.quantity
        end.sum
      end
    
      # get the line items
      def object_to_line_items(object)
        return object.line_items if object.is_a?(Spree::Order)
        return object.send(:order).line_items if object.respond_to?(:order)
        nil
      end
  end
end