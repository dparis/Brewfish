require 'brewfish'

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
    @red = Brewfish::Color.new( :named => :red )
    @blue = Brewfish::Color.new( :named => :blue )
    @white = Brewfish::Color.new( :named => :white )
    @black = Brewfish::Color.new( :named => :black )
    @player = Player.new
    @bombs = []
    @last_button_id = nil
  end

  def game_loop
    if button_down?( @last_button_id )
      on_button_down( @last_button_id )
    end

    clear_cells
    
    @bombs.each do |bomb|
      bomb_cell = cells[bomb.row][bomb.col]
      bomb_cell.tile = tileset['X']
      bomb_cell.fg_color = @red
      bomb_cell.bg_color = @black
    end
    
    player_cell = cells[@player.row][@player.col]
    player_cell.tile = tileset['@']
    player_cell.fg_color = @blue
    player_cell.bg_color = @white
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
      if @player.row < rows
        @player.row += 1
      end
    when keyboard_map[:kb_right]
      if @player.col < cols
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
