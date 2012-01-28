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
    def_delegators( :@console_delegate, :cells, :dirty_cells,
                                        :active_cells, :tiles, :width, :height,
                                        :rows, :cols )

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

    def game_setup
    end

    def game_loop
    end

    def game_start
      game_setup
      @console_delegate.show
    end
  end
end
