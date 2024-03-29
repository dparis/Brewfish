require 'brewfish'
require 'ruby-prof'

class Player
  attr_accessor :col, :row

  def initialize
    @col, @row = 0, 0
  end
end

class Bomb
  attr_accessor :col, :row

  def initialize( col=0, row=0 )
    @col, @row = col, row
  end
end

class Game < Brewfish::Console
  def clear_cells
    cells.flatten.each do |cell|
      cell.tile = nil
      cell.fg_color = nil
      cell.bg_color = nil
    end
  end

  def game_setup
    @i = 0

    @red = Brewfish::Color.new( :named => :red ).argb
    @blue = Brewfish::Color.new( :named => :blue ).argb
    @white = Brewfish::Color.new( :named => :white ).argb
    @black = Brewfish::Color.new( :named => :black ).argb

    @player = Player.new
    @bombs = []

    @last_button_id = keyboard_map[:kb_a]

    puts "rows/cols #{rows}/#{cols}"
  end

  def game_loop
    # if @i > 600
    #   game_close
    # end

    # @i += 1
      
    # if button_down?( @last_button_id )
    #   on_button_down( @last_button_id )
    # end

    @bombs.each do |bomb|
      bomb_cell = cells[bomb.row][bomb.col]
      bomb_cell.tile = tileset['X']
      bomb_cell.fg_argb = @red
      bomb_cell.bg_argb = @black
    end
    
    player_cell = cells[@player.row][@player.col]
    player_cell.tile = tileset['@']
    player_cell.fg_argb = @blue
    player_cell.bg_argb = @white
  end

  def on_button_down( button_id )
    @last_button_id = button_id

    case button_id
    when keyboard_map[:kb_escape]
      game_close
    when keyboard_map[:kb_a]
      @bombs << Bomb.new(rand(cols), rand(rows))
    when keyboard_map[:kb_up]
      if @player.row > 0
        @player.row -= 1
      end
    when keyboard_map[:kb_down]
      if @player.row < (rows-1)
        @player.row += 1
      end
    when keyboard_map[:kb_right]
      if @player.col < (cols-1)
        @player.col += 1
      end
    when keyboard_map[:kb_left]
      if @player.col > 0
        @player.col -= 1
      end
    end
  end

  def on_button_up( button_id )
    @last_button_id = nil
  end
end

console = Game.new( :type => :gosu, :show_fps => true )
console.game_start

#result = RubyProf.profile do
#  console.game_start
#end

#printer = RubyProf::CallTreePrinter.new(result)
#f = File.new('tmp/call_tree', 'w')
#printer.print(f, {})
