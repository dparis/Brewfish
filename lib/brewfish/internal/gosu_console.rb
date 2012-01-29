require 'gosu'

require_relative 'gosu_cell'
require_relative 'fps_counter'

module Internal
  class GosuConsole < Gosu::Window
    #----------------------------------------------------------------------------
    # Constants
    #----------------------------------------------------------------------------

    # Default options to init the object with
    # NOTE: Some options are passed through to Gosu::Window directly,
    # see Gosu documentation for more details:
    # http://www.libgosu.org/rdoc/Gosu/Window.html
    DEFAULT_INIT_OPTIONS = {
      :caption => 'BrewFish',
      :width => 1024,                           # Gosu::Window option
      :height => 768,                           # Gosu::Window option
      :fullscreen => false,                     # Gosu::Window option
      :update_interval => 16.666666,            # Gosu::Window option
      :tileset => {
        :tcod_font_png => :arial_12x12
      }
    }

    # Create a mapping of the Gosu::Kb* constants, with cleaned up keys
    KEYBOARD_MAP = Hash[ Gosu.constants.select{|c| c.to_s.match(/^Kb.*/)}.map do |constant|
                           new_constant = constant.to_s.gsub(/(.)([A-Z])/,'\1_\2').downcase.to_sym
                           [new_constant, Gosu.const_get( constant )]
                         end ]

    #----------------------------------------------------------------------------
    # Nested Class Modules
    #----------------------------------------------------------------------------

    # Rendering depths for draw operations on Gosu objects, with zero being
    # the lowest depth
    module ZOrder
      Background, Grid, Overlay = *0..2
    end


    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------
    attr_reader :cells, :tileset, :rows, :cols, :keyboard_map

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------

    # Subclass of Gosu::Window, override callbacks in order to update
    # and draw to window

    # Links:
    # https://github.com/jlnr/gosu/wiki/Window-Main-Loop
    # http://www.libgosu.org/rdoc/Gosu/Window.html
    # https://github.com/jlnr/gosu/wiki/Ruby-Tutorial

    def initialize( options = {} )
      # Load default values into options hash
      options = DEFAULT_INIT_OPTIONS.merge(options)

      # TODO: Support loading FPS rather than update interval in ms  --  Tue Jan 24 00:07:37 2012

      # Init the Gosu window through the parent class
      super( options[:width], options[:height],
             options[:fullscreen], options[:update_interval] )

      
      @tileset = Brewfish::Tileset.new( self, options[:tileset] )

      # Set up cells for drawing tiles to the window
      @cells = nil

      GosuCell.configure_dimensions( self )
      setup_cells
      
      # Set up callback target for things like calling a defined
      # game loop method from update
      # TODO: Custom Brewfish error type here  --  Fri Jan 27 11:05:11 2012
      raise "options[:callback_target] must be defined: #{options}" unless options[:callback_target]
      @callback_target = options[:callback_target]

      # Set up an FPS overlay
      if options[:show_fps]
        @fps = FPSCounter.new( self )
        @fps.show_fps = true
      end
    end

    def tile_width
      @tileset.tile_width
    end

    def tile_height
      @tileset.tile_height
    end

    def keyboard_map
      KEYBOARD_MAP
    end

    # Update method is called once per update interval, which is
    # specified in the options parameter passed to the class at time
    # of initialization
    def update
      @callback_target.game_loop

      if Cell.any_dirty?
        rebuild_grid_image
        Cell.drawn_all
      end
    end

    # Draw is called by Gosu::Window every time the OS wants the
    # screen to be redrawn, can also be limited by overriding
    # needs_redraw?, though according to Gosu documentation the OS may
    # still force a redraw for various reasons
    # http://www.libgosu.org/rdoc/Gosu/Window.html
    def draw
      # Draw the cell grid
      @cell_grid_image.draw( 0, 0, ZOrder::Grid )

      # Draw the FPS overlay if the object exists
      @fps.update if @fps
    end

    # Overriding needs_redraw? will let the object specify whether the
    # window needs to be redrawn, which will limit the amount of times
    # draw is called
    # def needs_redraw?
    #   redraw = false
    #   return redraw
    # end

    # button_down is called before update when the user pressed a
    # button while the window had focus
    def button_down( button_id )
      # Call back to the proxy object
      @callback_target.on_button_down( button_id )
    end

    # button_up is called before update when the user released a
    # button while the window had focus
    def button_up( button_id )
      # Call back to the proxy object
      @callback_target.on_button_up( button_id )
    end

    #----------------------------------------------------------------------------
    # Private Instance Methods
    #----------------------------------------------------------------------------
    private

    # Called from the initialize method, this will configure an array
    # of Cell instances based on the maximum number of cells in each
    # row and column of the window
    def setup_cells
      # The max_cols and max_rows are determined based on the window
      # dimensions passed into the GosuCell.configure_dimensions
      # method during window init
      @cols = GosuCell.max_cols
      @rows = GosuCell.max_rows

      @cells = []

      @rows.times do |row_index|
        row = []
        
        @cols.times do |col_index|
          row << GosuCell.new( col_index, row_index )
        end

        @cells << row
      end

      # Flatten the nested cell arrays so that drawing ops have a
      # slightly optimized way to iterate over all cells
      @cell_draw_array = @cells.flatten
    end

    # Rebuild the grid image data using the Gosu::Window#record method
    # to batch all of the drawing operations 
    def rebuild_grid_image
      @cell_grid_image = self.record( self.width, self.height ) do
        @cell_draw_array.each do |cell|
          cell.draw
        end
      end
    end
  end
end

