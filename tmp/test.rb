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
  def game_setup
    @i = 0
    @bomb_count = 0

    @red = Brewfish::Color.new( :named => :red ).argb
    @blue = Brewfish::Color.new( :named => :blue ).argb
    @white = Brewfish::Color.new( :named => :white ).argb
    @black = Brewfish::Color.new( :named => :black ).argb

    @player = Player.new( 0, 3 )
    @bombs = []

    @last_button_id = keyboard_map[:kb_a]
    @map = Brewfish::Map.load_from_file( 'tmp/test_map.txt' )
  end

  def is_walkable?( x, y )
    puts [x,y,@map.width, @map.height].to_s
    if x < 0 || x > unit_width || y < 0 || y > unit_height || x == @map.width || y == @map.height
      return false
    end
    
    map_data = @map.get_data_at( x, y )
    return map_data[:tile_id] == ' ' ? true : false
  end

  def game_loop
    #if button_down?( @last_button_id )
    #  on_button_down( @last_button_id )
    #end

    @map.data.each_index do |y_index|
      @map.data[y_index].each_index do |x_index|
        data = @map.data[y_index][x_index]
        cell = cells[y_index][x_index]
        cell.tile = tileset[data[:tile_id]]
        cell.bg_argb = @white
        cell.fg_argb = @red
      end
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
      if is_walkable?( @player.x, @player.y - 1 )
        @player.y -= 1
      end
    when keyboard_map[:kb_down]
      if is_walkable?( @player.x, @player.y + 1 )
        @player.y += 1
      end
    when keyboard_map[:kb_right]
      if is_walkable?( @player.x + 1, @player.y )
        @player.x += 1
      end
    when keyboard_map[:kb_left]
      if is_walkable?( @player.x - 1, @player.y )
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

console = Game.new( :type => :gosu )
console.game_start

#result = RubyProf.profile do
#  console.game_start
#end

#printer = RubyProf::CallTreePrinter.new(result)
#f = File.new('tmp/call_tree', 'w')
#printer.print(f, {})
