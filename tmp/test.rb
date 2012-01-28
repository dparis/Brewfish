require 'brewfish'

class Game < Brewfish::Console
  def game_setup
    @i = 0
    @red = Brewfish::Color.new( :named => :red )
  end

  def game_loop
    if (@i % 6) == 0
      cell = cells[rand(rows)][rand(cols)]
      cell.tile = tiles['X']
      cell.fg_color = @red
    end
  end
end

console = Game.new( :type => :gosu, :show_fps => true )
console.game_start
