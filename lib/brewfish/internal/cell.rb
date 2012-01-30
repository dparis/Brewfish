require 'pry'

module Internal
  class Cell
    DEFAULT_INIT_OPTIONS = {
      :char => nil,
      :tile => nil,
      :bg_color => nil,
      :fg_color => nil
    }

    attr_reader :x, :y, :tile, :char, :bg_argb, :fg_argb
    attr_writer :dirty

    @@console = nil

    @@console_width  = nil
    @@console_height = nil

    @@max_x = nil
    @@max_y = nil

    @@any_dirty = true

    def initialize( x, y, options = {} )
      options = DEFAULT_INIT_OPTIONS.merge( options )

      @x, @y = x, y

      @char = options[:char]
      @tile = options[:tile]

      # Handle color options
      self.bg_argb = options[:bg_argb]
      self.fg_argb = options[:fg_argb]

      # Default to dirty to ensure initial rendering
      self.dirty = true
    end

    def tile=( tile )
      self.dirty = true unless tile == @tile
      @tile = tile
    end

    def char=( char )
      self.dirty = true unless char == @char
      @char = char
    end

    def bg_argb=( bg_argb )
      self.dirty = true unless bg_argb == @bg_argb
      @bg_argb = bg_argb
    end

    def fg_argb=( fg_argb )
      self.dirty = true unless fg_argb == @fg_argb
      @fg_argb = fg_argb
    end

    def dirty?
      @dirty
    end

    def dirty=( is_dirty )
      @dirty = is_dirty
      @@any_dirty = true if is_dirty
    end

    def draw
    end

    def clear
      @tile = nil
      @char = nil
      @bg_argb = nil
      @fg_argb = nil
    end

    class << self
      def configure_dimensions( console )
        @@console = console

        @@console_width  = console.width
        @@console_height = console.height

        @@unit_width  = @@console_width
        @@unit_height = @@console_height
      end

      def any_dirty?
        @@any_dirty
      end

      def drawn_all
        @@any_dirty = false
      end
    end
  end
end
