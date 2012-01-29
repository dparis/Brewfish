require 'pry'

module Internal
  class Cell
    DEFAULT_INIT_OPTIONS = {
      :char => nil,
      :tile => nil,
      :bg_color => nil,
      :fg_color => nil
    }

    attr_reader :x, :y, :col, :row, :tile, :char, :bg_argb, :fg_argb
    attr_writer :dirty

    @@console = nil

    @@console_width  = nil
    @@console_height = nil

    @@max_cols = nil
    @@max_rows = nil

    @@max_x = nil
    @@max_y = nil

    @@any_dirty = true

    def initialize( row, col, options = {} )
      options = DEFAULT_INIT_OPTIONS.merge( options )

      @row = row
      @col = col

      @char = options[:char]
      @tile = options[:tile]

      # Handle color options
      self.bg_argb = options[:bg_argb]
      self.fg_argb = options[:fg_argb]

      # Default to dirty to ensure initial rendering
      self.dirty = true

      calculate_x_y
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

    class << self
      def configure_dimensions( console )
        @@console = console

        @@console_width  = console.width
        @@console_height = console.height

        @@max_x = @@console_width
        @@max_y = @@console_height

        @@max_cols = @@max_x
        @@max_rows = @@max_y
      end

      def any_dirty?
        @@any_dirty
      end

      def drawn_all
        @@any_dirty = false
      end
    end

    private

    def calculate_x_y
      @x = @col
      @y = @row
    end
  end
end
