require_relative 'cell'
require_relative 'gosu_console'
require 'pry'

module Internal
  class GosuCell < Cell
    #----------------------------------------------------------------------------
    # Class Variables
    #----------------------------------------------------------------------------
    @@cell_pixel_width  = nil
    @@cell_pixel_height = nil

    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------
    attr_reader :pixel_x, :pixel_y
    

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    def initialize( x, y, options = {} )
      super
      calculate_pixel_x_y
    end
    
    def draw
      if @tile && @bg_argb && @fg_argb
        # Draw the background color
        @@console.draw_quad( @quad_x1, @quad_y1, @bg_argb,  # Top Left
                             @quad_x2, @quad_y2, @bg_argb,  # Top Right
                             @quad_x3, @quad_y3, @bg_argb,  # Bottom Left
                             @quad_x4, @quad_y4, @bg_argb,  # Bottom Right
                             Internal::GosuConsole::ZOrder::Background )
        
        # Draw the tile
        @tile.draw( @pixel_x, @pixel_y, Internal::GosuConsole::ZOrder::Grid, 1, 1, @fg_argb )
        @dirty = false
      end
    end

    #----------------------------------------------------------------------------
    # Class Methods
    #----------------------------------------------------------------------------
    class << self
      def configure_dimensions( console )
        @@console = console

        @@console_pixel_width  = console.pixel_width
        @@console_pixel_height = console.pixel_height

        # TODO: Check here to ensure tileset is not nil  --  Sun Jan 29 14:36:27 2012
        @@cell_pixel_width  = console.tileset.tile_width
        @@cell_pixel_height = console.tileset.tile_height

        # Maximum x value for cells can be found by finding the number
        # of times the cell width can go into the console width evenly
        # and multiplying the cell width by that number
        @@max_pixel_x = ( @@console_pixel_width.divmod(@@cell_pixel_width).first ) * @@cell_pixel_width

        # Same process for maximum y value, except use cell/console height
        @@max_pixel_y = ( @@console_pixel_height.divmod(@@cell_pixel_height).first ) * @@cell_pixel_height

        # Set the max number of rows and columns based on the current
        # cell and console heights
        @@unit_width = @@max_pixel_x / @@cell_pixel_width
        @@unit_height = @@max_pixel_y / @@cell_pixel_height

        if @@unit_width == 16
          binding.pry
        end
      end

      def unit_width
        @@unit_width
      end

      def unit_height
        @@unit_height
      end
    end

    private

    def calculate_pixel_x_y
      # TODO: Create Brewfish error type  --  Tue Jan 24 02:04:11 2012
      unless @@cell_pixel_width && @@cell_pixel_height && @@console_pixel_width && @@console_pixel_height
        raise "Must call configure_dimensions on class before before x/y can be calculated"
      end

      @pixel_x = @x * @@cell_pixel_width
      @pixel_y = @y * @@cell_pixel_height

      @quad_x1, @quad_y1 = @pixel_x, @pixel_y                                                             # Top Left
      @quad_x2, @quad_y2 = ((@pixel_x + @@cell_pixel_width)), @pixel_y                                    # Top Right
      @quad_x3, @quad_y3 = @pixel_x, ((@pixel_y + @@cell_pixel_height))                                   # Bottom Left
      @quad_x4, @quad_y4 = ((@pixel_x + @@cell_pixel_width)), ((@pixel_y + @@cell_pixel_height))          # Bottom Right
    end
  end
end
