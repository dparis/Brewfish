module Brewfish
  module Util
    module Math
      def clamp(number, range)
        # Nested ternary operators:
        # If number < the min, return min, otherwise if number is
        # greater than the max, return the max, otherwise return the number
        ( number < range.min ) ? range.min : ( number > range.max ) ? range.max : number
      end

      module_function :clamp
    end

    module Colors
    end
  end
end
