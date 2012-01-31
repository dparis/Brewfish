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
    @world_map = Brewfish::Map.load_from_file( 'tmp/test_map.txt' )
    @map_offset_x = 0
    @map_offset_y = 0
  end

  def is_walkable?( x, y )
    map_data = @world_map.get_data_at( x, y )
    return map_data[:tile_id] == ' ' ? true : false
  end

  def scroll_map?( x, y )
    scroll = true
    
    if x < 0 || y < 0 ||  x == @map.width || y == @map.height
      scroll = false
    end

    puts "Scrolling map: #{scroll.to_s}"
    return scroll
  end

  def game_loop
    #if button_down?( @last_button_id )
    #  on_button_down( @last_button_id )
    #end

    @map = @world_map.get_sub_map( @map_offset_x, @map_offset_y, unit_width, unit_height )

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
      else scroll_map?( @player.x, @player.y - 1 )
        @map_offset_y -= 1 if @map_offset_y > 0
      end
    when keyboard_map[:kb_down]
      if is_walkable?( @player.x, @player.y + 1 )
        @player.y += 1
      else scroll_map?( @player.x, @player.y + 1 )
        @map_offset_y += 1 if @map_offset_y < unit_height
      end
    when keyboard_map[:kb_right]
      if is_walkable?( @player.x + 1, @player.y )
        @player.x += 1
      else scroll_map?( @player.x + 1, @player.y )
        @map_offset_x += 1 if @map_offset_x < unit_width
      end
    when keyboard_map[:kb_left]
      if is_walkable?( @player.x - 1, @player.y )
        @player.x -= 1
      else scroll_map?( @player.x - 1, @player.y )
        @map_offset_x -= 1 if @map_offset_x > 0
      end
    when keyboard_map[:kb_b]
      puts @bomb_count
    end
  end

  def on_button_up( button_id )
    @last_button_id = nil
  end
end

console = Game.new( :type => :gosu, :pixel_width => 240, :pixel_height => 120 )
console.game_start

#result = RubyProf.profile do
#  console.game_start
#end

#printer = RubyProf::CallTreePrinter.new(result)
#f = File.new('tmp/call_tree', 'w')
#printer.print(f, {})
