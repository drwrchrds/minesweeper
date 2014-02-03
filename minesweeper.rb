class Game
  def initialize(player)
    @player = player
    @grid = Grid.new(...)
  end

  def play
    until @grid.over?
      player.play_turn
    end
  end
end

class Grid

  attr_accessor :lost, :won

  def initialize(game, size = "S", difficulty)
    @game, @size, @difficulty = game, size, difficulty
    @board = self.build_grid
  end

  def build_grid
    side_length = 0
    case @size
      when "S"
        side_length = 8
      when "M"
        side_length = 12
      when "L"
        side_length = 16
    end
    grid = []
    side_length.times do |row|
      side_length.times do |col|
        # let's make sure this works
        if rand(3) > difficulty
          bomb = true
        else
          bomb = false
        end
        tile = Tile.new(self, [row, col],bomb)
      end
    end
  end

  def over?
    lost || won?
  end

  def blowup!
    self.lost = true
  end

  def won?

  end


end

class Tile
  attr_reader :pos, :bomb, :flagged, :revealed, :grid
  attr_accessor :symbol

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

  def flag
    @flagged = !@flagged
    self.symbol = ( self.symbol == "F" ? " " : "F")
  end

  def reveal!
    break if @revealed
    @revealed = true
    if self.bomb
      grid.blowup!
      self.symbol = "B"
    else
      self.get_adjacent_tiles
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
    self.symbol = num_bombs
    if num_bombs == 0
      adjacent_tiles.each do |tile|
        tile.reveal!
      end
    end
  end
end
