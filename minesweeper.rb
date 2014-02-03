class Game
  def initialize(player)
    @player = player
  end
end

class Grid

  attr_accessor :loss, :win

  def initialize(game, side_length, difficulty)
    @game, @side_length, @difficulty = game, side_length, difficulty
  end

  def over?
    loss || win
  end

  def blowup!
    self.loss = true
  end

end

class Tile
  attr_reader :pos, :bomb, :flagged, :revealed, :grid

  ADJ_TILES = [
    [-1, -1],
    [-1, 0],
    [-1, 1],
    [0, -1],
    [0, 1],
    [1, -1],
    [1, 0],
    [1, 1]
  ]

  def initialize(grid, pos, bomb)
    @grid, @pos, @bomb = grid, pos, bomb
    @flagged = false
    @revealed = false
  end

  def flag
    @flagged = !@flagged
  end

  def reveal!
    break if @revealed
    @revealed = true
    if self.bomb
      grid.blowup!
    end
  end

  def get_adjacent_tiles
    num_bombs = 0
    adjacent_tiles = []
    # collect adjacent tile positions
    ADJ_TILES.dup.each do |tile|
      new_tile = grid[[self.pos[0] + tile[0]][self.pos[1] + tile[1]]
      next if !grid[new_tile[0]][new_tile[1]]
      adjacent_tiles << new_tile
        if new_tile.bomb
          num_bombs += 1
        end
      end
      if num_bombs == 0
        adjacent_tiles.each do |tile|
          tile.reveal!
          tile.get_adjacent_tiles
        end


  end

  def how_many_bombs
  end
end
