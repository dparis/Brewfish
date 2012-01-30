require 'brewfish'
require 'ruby-prof'

class Player
  attr_accessor :x, :y

  def initialize( x=0, y=0 )
    @x, @y = x, y
  end
end

class Bomb
  attr_accessor :x, :y

  def initialize( x=0, y=0 )
    @x, @y = x, y
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
    @bomb_count = 0

    @red = Brewfish::Color.new( :named => :red ).argb
    @blue = Brewfish::Color.new( :named => :blue ).argb
    @white = Brewfish::Color.new( :named => :white ).argb
    @black = Brewfish::Color.new( :named => :black ).argb

    @player = Player.new
    @bombs = []

    @last_button_id = keyboard_map[:kb_a]
  end

  def game_loop
    # if @i > 600
    #   game_close
    # end

    # @i += 1
      
    if button_down?( @last_button_id )
      on_button_down( @last_button_id )
    end

    @bombs.each do |bomb|
      bomb_cell = cells[bomb.y][bomb.x]
      bomb_cell.tile = tileset['X']
      bomb_cell.fg_argb = @red
      bomb_cell.bg_argb = @black
    end
    
    player_cell = cells[@player.y][@player.x]
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
      @bombs << Bomb.new(rand(unit_width), rand(unit_height))
      @bomb_count += 1
    when keyboard_map[:kb_up]
      if @player.y > 0
        @player.y -= 1
      end
    when keyboard_map[:kb_down]
      if @player.y < (unit_height-1)
        @player.y += 1
      end
    when keyboard_map[:kb_right]
      if @player.x < (unit_width-1)
        @player.x += 1
      end
    when keyboard_map[:kb_left]
      if @player.x > 0
        @player.x -= 1
      end
    when keyboard_map[:kb_b]
      puts @bomb_count
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
