class Tile
  attr_reader :pos, :bomb, :revealed, :grid
  attr_accessor :symbol, :flagged

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
    @symbol = " " # starts out as space
  end

  def revealed?
    @revealed
  end

  def reveal!
    return if self.revealed?
    @revealed = true
    if self.bomb
      grid.lost_board
    else
      self.get_adjacent_tiles
    end
  end

  def get_adjacent_tiles
    num_bombs = 0
    adjacent_tiles = []
    # collect adjacent tile positions
    ADJ_TILES.dup.each do |tile|

      new_tile = grid[[self.pos[0] + tile[0], self.pos[1] + tile[1]]]
      # p new_tile
      next unless new_tile
      adjacent_tiles << new_tile
      if new_tile.bomb
        num_bombs += 1
      end
    end
    self.symbol = num_bombs
    if num_bombs == 0
      adjacent_tiles.each do |tile|
        tile.reveal!
      end
    end
    nil
  end
end
