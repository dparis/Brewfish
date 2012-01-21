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
      def hsv_to_hsl( hsv_h, hsv_s, hsv_v )
        # Early out if hsv_v is zero to avoid divide-by-zero error
        return [0, 0, 0] if hsv_v == 0

        # Ensure that hsv_h is between 0 and 359 degrees
        hsv_h = hsv_h % 360

        # If either hsv_s or hsv_v are greater than 1, assume a percentage was
        # passed in and convert
        hsv_s = hsv_s / 100 if hsv_s > 1
        hsv_v = hsv_v / 100 if hsv_v > 1
        
        # Clamp hsv_s and hsv_v between 0 and 1
        percent_range = (0.0..1.0)
        hsv_s = Brewfish::Util::Math.clamp( hsv_s, percent_range )
        hsv_v = Brewfish::Util::Math.clamp( hsv_v, percent_range )

        # Round before performing any calculations
        hsv_s = hsv_s.round(4)
        hsv_v = hsv_v.round(4)

        # Perform conversion according to code found at this link,
        # based on wikipedia information:
        # http://ariya.blogspot.com/2008/07/converting-between-hsl-and-hsv.html
        hsl_h = hsv_h
        hsl_l = ( 2 - hsv_s ) * hsv_v
        hsl_s = hsv_s * hsv_v

        if hsl_l <= 1
          hsl_s = hsl_s / hsl_l
        else
          hsl_s = hsl_s / ( 2 - hsl_l )
        end
        
        hsl_l = hsl_l / 2

        hsl_s = hsl_s.round(4)
        hsl_l = hsl_l.round(4)

        return [hsl_h, hsl_s, hsl_l]
      end

      def hsl_to_hsv( hsl_h, hsl_s, hsl_l )
        # Early out if hsl_l is zero to avoid divide-by-zero error
        return [0, 0, 0] if hsl_l == 0

        # Ensure that hsl_h is between 0 and 359 degrees
        hsl_h = hsl_h % 360

        # If either hsl_s or hsl_l are greater than 1, assume a percentage was
        # passed in and convert
        hsl_s = hsl_s / 100 if hsl_s > 1
        hsl_l = hsl_l / 100 if hsl_l > 1
        
        # Clamp hsl_s and hsl_l between 0 and 1
        percent_range = (0.0..1.0)
        hsl_s = Brewfish::Util::Math.clamp( hsl_s, percent_range )
        hsl_l = Brewfish::Util::Math.clamp( hsl_l, percent_range )

        # Round before performing any calculations
        hsl_s = hsl_s.round(4)
        hsl_l = hsl_l.round(4)

        # Perform conversion according to code found at this link,
        # based on wikipedia information:
        # http://ariya.blogspot.com/2008/07/converting-between-hsl-and-hsv.html
        hsv_h = hsl_h;
        hsl_l = hsl_l * 2
        
        if hsl_l <= 1
          hsl_s = hsl_s * hsl_l
        else
          hsl_s = hsl_s * ( 2 - hsl_l )
        end

        hsv_v = ( hsl_l + hsl_s ) / 2
        hsv_s = ( 2 * hsl_s ) / ( hsl_l + hsl_s )

        hsv_s = hsv_s.round(4)
        hsv_v = hsv_v.round(4)

        return [hsv_h, hsv_s, hsv_v]
      end

      module_function :hsv_to_hsl, :hsl_to_hsv
    end
  end
end
