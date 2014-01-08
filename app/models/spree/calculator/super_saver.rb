module Spree
  class Calculator::SuperSaver < Calculator
    preference :default_item_weight, :decimal, :default => 0
    
    # If we wanted to get input from the user for compute()
    #preference :amount, :decimal, :default => 0

    def self.description
      "Super Saver"
    end

    def compute(object)
      line_items = object_to_line_items(object)
      return nil if line_items.nil?
      
      books_taxon = Spree::Taxon.find(3)
      dvds_taxon = Spree::Taxon.find_by_name(5)
      
      # Flag to indicate if order has anything but books/dvds
      order_has_unacceptable_item = false
      
      # Iterate line items and set the flag if we run into a non dvd/book item
      # If the flag is set, we know that this shipping method isnt for them, return nil
      line_items.each do |li|
        if books_taxon.products.map(&:id).include?(li.product.id) or dvds_taxon.products.map(&:id).include?(li.product.id)
          order_has_unacceptable_item = false
        else
          order_has_unacceptable_item = true
        end
      end
      
      total_weight = get_total_weight(line_items)
      
      if order_has_unacceptable_item == true
        nil
      else
        # Option is available ($4.00) if the order is between 13 and 48 oz (3 lbs)
        if total_weight >= 13 and total_weight < 48
          4.5
        else
          nil
        end 
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