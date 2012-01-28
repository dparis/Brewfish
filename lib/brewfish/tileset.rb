require 'gosu'

require_relative 'internal/font_info'

module Brewfish
  class Tileset
    #----------------------------------------------------------------------------
    # Constants
    #----------------------------------------------------------------------------

    # Default location for font tile image files, relative to gem root
    DEFAULT_FONT_DIR = 'data/tiles/fonts/'

    # Default location for sprite tile image files, relative to gem root
    DEFAULT_SPRITE_DIR = 'data/tiles/sprites/'
   
    #----------------------------------------------------------------------------
    # Attributes
    #----------------------------------------------------------------------------
    attr_reader :file_name, :file_path, :tile_width, :tile_height

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    def initialize( gosu_window, options )
      # Store a reference to the Gosu::Window object so that tiles can
      # be loaded during subsequent calls to load_tiles
      @gosu_window = gosu_window

      # Load the tiles using the specified settings
      load_tiles( options )
    end

    def load_tiles( options )
      unless options.respond_to?( :count ) && options.count == 1
        raise ArgumentError, "Cannot pass more than one tileset type"
      end
      
      tileset_type, tileset_settings = options.first

      case tileset_type
      when :tcod_font_png
        # A libtcod compatible console font file, stored in a png image
        # file with each ASCII character indexed to a specific
        # position on the tilemap
        unless tileset_settings
          valid_settings = Internal::FONT_INFO.keys.join(', ')
          raise( ArgumentError, "Invalid TCOD font setting, must specify one of the following: #{valid_settings}" )
        end

        # Load the font image as Gosu::Image tile objects
        font_info = Internal::FONT_INFO[tileset_settings]
        path = File.join( Brewfish.root, DEFAULT_FONT_DIR, 'tcod' )

        @file_name = font_info[:file]
        @file_path = path

        full_font_path = File.join( @file_path, @file_name )
        font_images = Gosu::Image.load_tiles( @gosu_window, full_font_path, font_info[:width],
                                              font_info[:height], true )

        # Set up a hash of ASCII -> Gosu::Image tiles objects
        @tiles = {}

        @tile_width  = font_info[:width]
        @tile_height = font_info[:height]
        
        Internal::FontImgAsciiMap::TCOD.count.times do |map_index|
          @tiles[map_index.chr] = font_images[Internal::FontImgAsciiMap::TCOD[map_index]]
        end
      else
        raise ArgumentError, "Invalid font type: #{tileset_type}"
      end
    end

    def []( tile_key )
      @tiles[tile_key]
    end
  end
end
