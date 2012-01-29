require_relative 'cell'
require_relative 'gosu_console'

module Internal
  class GosuCell < Cell
    @@cell_width  = nil
    @@cell_height = nil
    
    def draw
      if @tile && @bg_argb && @fg_argb
        # Draw the background color
        @@console.draw_quad( @quad_x1, @quad_y1, @bg_argb,  # Top Left
                             @quad_x2, @quad_y2, @bg_argb,  # Top Right
                             @quad_x3, @quad_y3, @bg_argb,  # Bottom Left
                             @quad_x4, @quad_y4, @bg_argb,  # Bottom Right
                             Internal::GosuConsole::ZOrder::Background )
        
        # Draw the tile
        @tile.draw( @x, @y, Internal::GosuConsole::ZOrder::Grid, 1, 1, @fg_argb )
        @dirty = false
      end
    end

    class << self
      def configure_dimensions( console )
        @@console = console

        @@console_width  = console.width
        @@console_height = console.height

        @@cell_width  = console.tile_width
        @@cell_height = console.tile_height

        # Maximum x value for cells can be found by finding the number
        # of times the cell width can go into the console width evenly
        # and multiplying the cell width by that number minus one
        @@max_x = ( @@console_width.divmod(@@cell_width).first ) * @@cell_width

        # Same process for maximum y value, except use cell/console height
        @@max_y = ( @@console_height.divmod(@@cell_height).first ) * @@cell_height

        # Set the max number of rows and columns based on the current
        # cell and console heights
        @@max_cols = @@max_x / @@cell_width
        @@max_rows = @@max_y / @@cell_height
      end

      def max_cols
        @@max_cols
      end

      def max_rows
        @@max_rows
      end
    end

    private

    def calculate_x_y
      # TODO: Create Brewfish error type  --  Tue Jan 24 02:04:11 2012
      unless @@cell_width && @@cell_height && @@console_width && @@console_height
        raise "Must call configure_dimensions on class before before x/y can be calculated"
      end

      @x = @col * @@cell_width
      @y = @row * @@cell_height

      @quad_x1, @quad_y1 = @x, @y                                                     # Top Left
      @quad_x2, @quad_y2 = @x, ((@y + @@cell_height) - 1)                             # Bottom Left
      @quad_x3, @quad_y3 = ((@x + @@cell_width) - 1), @y                              # Top Right
      @quad_x4, @quad_y4 = ((@x + @@cell_width) - 1), ((@y + @@cell_height) - 1)      # Bottom Right
    end
  end
end
