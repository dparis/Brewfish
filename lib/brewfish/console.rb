require 'forwardable'
require 'gosu'

require_relative 'color'
require_relative 'internal/gosu_console'

module Brewfish
  class Console
    extend Forwardable

    #----------------------------------------------------------------------------
    # Delegated Methods
    #----------------------------------------------------------------------------
    def_delegators( :@console_delegate, :cells, :tileset, :width, :height,
                                        :rows, :cols, :button_down?, :keyboard_map )

    # Method descriptions
    #
    # cells - Returns a nested array of Brewfish::Internal::Cell instances
    #         configured to the dimensions of the Console instance
    #
    # tileset - Returns a Brewfish::Tileset instance configured with
    #           the settings specified during initialization of the
    #           Console instance
    #
    # width - Returns the pixel width of the Console instance
    #
    # height - Returns the pixel height of the Console instance
    #
    # rows - Returns the number of cell rows addressable by the
    #        Console instance
    #
    #
    # cols - Returns the number of cell columns addressable by the
    #        Console instance
    #
    # button_down? - Return boolean indicating whether a given button
    #                id is being held down; only valid within the
    #                context of game_loop
    #
    # keyboard_map - Returns a hash mapping keyboard button codes to
    #                their button ids for use in button_down?;
    #                numerical codes may differ based on keyboard layouts,
    #                implementations, etc
    #

    #----------------------------------------------------------------------------
    # Instance Methods
    #----------------------------------------------------------------------------
    def initialize( options = {} )
      # Default to Gosu rendered console
      options[:type] ||= :gosu

      case options[:type]
      when :gosu
        options[:callback_target] = self
        @console_delegate = Internal::GosuConsole.new( options )
      else
        # TODO: Custome Brewfish error type here  --  Thu Jan 26 21:35:41 2012
        raise "Unsupported Console type: #{options[:type]}"
      end
    end

    # Override in the subclass to provide a place to do initialization
    # of game logic, load files, set up state, etc
    def game_setup
    end

    # Called every update interval while the console is being shown 
    def game_loop
    end

    # Called on an instance of the subclass, this will run the
    # game_setup method and then begin the show loop on the delegate
    def game_start
      game_setup
      @console_delegate.show
    end

    # Calling this method cause the game window to stop rendering and close
    def game_close
      @console_delegate.close
    end

    # Override in the subclass in order to handle single button
    # presses, called before game_loop; keyboard_map provides a map
    # between keyboard_code => button_id
    def on_button_down( button_id )
    end

    def on_button_up( button_id )
    end
  end
end
