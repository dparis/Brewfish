require 'gosu'

require_relative 'gosu_cell'

module Internal
  class GosuConsole < Gosu::Window
    #----------------------------------------------------------------------------
    # Constants
    #----------------------------------------------------------------------------
    DEFAULT_FONT_DIR = 'data/fonts/'

    DEFAULT_INIT_OPTIONS = {
      :caption => 'BrewFish',
      :width => 1024,
      :height => 768,
      :fullscreen => false,
      :update_interval => 16.666666,
      :font => {
        :tcod_png => {
          :file => 'tcod/arial12x12.png'
        }
      }
    }


    #----------------------------------------------------------------------------
    # Nested Class Modules
    #----------------------------------------------------------------------------
    module ZOrder
      Background, Grid, Overlay = *0..2
    end

    module FontImgAsciiMap
      TCOD = [ 0,  0,  0,  0,  0,  0,  0,  0,  0,  76, 77, 0,  0,  0,  0,  0,   # ASCII 0 to 15
               71, 70, 72, 0,  0,  0,  0,  0,  64, 65, 67, 66, 0,  73, 68, 69,  # ASCII 16 to 31
               0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  10, 11, 12, 13, 14, 15,  # ASCII 32 to 47
               16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,  # ASCII 48 to 63
               32, 96, 97, 98, 99, 100,101,102,103,104,105,106,107,108,109,110, # ASCII 64 to 79
               111,112,113,114,115,116,117,118,119,120,121,33, 34, 35, 36, 37,  # ASCII 80 to 95
               38, 128,129,130,131,132,133,134,135,136,137,138,139,140,141,142, # ASCII 96 to 111
               143,144,145,146,147,148,149,150,151,152,153,39, 40, 41, 42, 0,   # ASCII 112 to 127
               0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   # ASCII 128 to 143
               0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   # ASCII 144 to 159
               0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,   # ASCII 160 to 175
               43, 44, 45, 46, 49, 0,  0,  0,  0,  81, 78, 87, 88, 0,  0,  55,  # ASCII 176 to 191
               53, 50, 52, 51, 47, 48, 0,  0,  85, 86, 82, 84, 83, 79, 80, 0,   # ASCII 192 to 207
               0,  0,  0,  0,  0,  0,  0,  0,  0,  56, 54, 0,  0,  0,  0,  0,   # ASCII 208 to 223
               74, 75, 57, 58, 59, 60, 61, 62, 63, 0,  0,  0,  0,  0,  0,  0,   # ASCII 224 to 239
               0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, ] # ASCII 240 to 255
    end

    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------
    attr_reader :tile_width, :tile_height, :cells, :tiles

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
      
      # Load Gosu::Font from the options passed
      @font = nil

      font_type, font_settings = options[:font].first
      
      case font_type
      when :tcod_png
        # A libtcod compatible console font file, stored in a png image
        # file with each ASCII character indexed to a specific
        # position on the tilemap
        unless font_settings[:file]
          raise ArgumentError, 'Invalid font setting, must specify :font'
        end

        # Extract the char tile widthxheight from the filename if it's
        # properly formatted to contain those values
        font_filename = font_settings[:file]
        size_match = font_filename.match(/(\d+x\d+)/)

        char_width, char_height = size_match[1].split('x').map{|size| size.to_i} if size_match

        # Override with explicit options if present
        char_width  = font_settings[:width].to_i  if font_settings[:width]
        char_height = font_settings[:height].to_i if font_settings[:height]

        # Load the font image as Gosu::Image tile objects
        font_images = Gosu::Image.load_tiles( self, DEFAULT_FONT_DIR + font_filename,
                                              char_width, char_height, true )

        # Set up a hash of ASCII -> Gosu::Image tiles objects
        @tiles = {}

        @tile_width  = char_width
        @tile_height = char_height
        
        FontImgAsciiMap::TCOD.count.times do |map_index|
          @tiles[map_index.chr] = font_images[FontImgAsciiMap::TCOD[map_index]]
        end
      else
        raise ArgumentError, "Invalid font type: #{font_type}"
      end

      # Set up cells for drawing characters or tiles to the window
      @cells = nil

      GosuCell.configure_dimensions( self )
      setup_cells

      # Set up callback target for things like calling a defined
      # game loop method from update
      # TODO: Custom Brewfish error type here  --  Fri Jan 27 11:05:11 2012
      raise "options[:callback_target] must be defined: #{options}" unless options[:callback_target]
      @callback_target = options[:callback_target]
    end

    def update
      @callback_target.game_loop
    end

    def draw
      active_cells.each do |cell|
        cell.draw
      end
    end

    def set_char_at( col, row, char )
      @cells[row][col].char = char
    end

    def set_tile_at( col, row, tile )
      @cells[row][col].tile = tile
    end

    #----------------------------------------------------------------------------
    # Protected Instance Methods
    #----------------------------------------------------------------------------
    protected

    def setup_cells
      cols = GosuCell.max_cols
      rows = GosuCell.max_rows

      @cells = []

      rows.times do |row_index|
        row = []
        
        cols.times do |col_index|
          row << GosuCell.new( col_index, row_index )
        end

        @cells << row
      end
    end
    
    #----------------------------------------------------------------------------
    # Private Instance Methods
    #----------------------------------------------------------------------------
    private

    def dirty_cells
      @cells.flatten.select{|c| c.dirty?}
    end

    def active_cells
      @cells.flatten.select{|c| c.tile || c.char}
    end
  end
end

