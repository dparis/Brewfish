module Internal
  class Cell
    DEFAULT_INIT_OPTIONS = {
      :char => nil,
      :tile => nil,
      :bg_color => Brewfish::Color.new( :named => :black ),
      :fg_color => Brewfish::Color.new( :named => :white )
    }

    attr_reader :x, :y, :col, :row, :tile, :char, :bg_color, :fg_color
    attr_writer :dirty

    @@console = nil

    @@console_width  = nil
    @@console_height = nil

    @@max_cols = nil
    @@max_rows = nil

    @@max_x = nil
    @@max_y = nil

    @@any_dirty = true

    def initialize( col, row, options = {} )
      options = DEFAULT_INIT_OPTIONS.merge( options )

      @col = col
      @row = row

      @char = options[:char]
      @tile = options[:tile]

      # Handle color options
      self.bg_color = options[:bg_color]
      self.fg_color = options[:fg_color]

      # Default to dirty to ensure initial rendering
      self.dirty = true

      calculate_x_y
    end

    def tile=( tile )
      @tile = tile
      self.dirty = true
    end

    def char=( char )
      @char = char
      self.dirty = true
    end

    def bg_color=( bg_color )
      @bg_color = bg_color
      @bg_argb = bg_color.argb
      self.dirty = true
    end

    def fg_color=( fg_color )
      @fg_color = fg_color
      @fg_argb = fg_color.argb
      self.dirty = true
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
