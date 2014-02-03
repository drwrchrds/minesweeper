class Game
  def initialize(name)
    @player = name
    @grid = Grid.new(self)
  end

  def play
    until @grid.over?
      @grid.show
      pos = play_turn
      @grid[pos].reveal!
    end

    if @grid.won?
      @grid.all_reveal!
      p "You found all the bombs"
    else
      @grid.blowup!
      p "EVERYONE DIES!!!!"
    end
  end

  def play_turn
    decision = nil
    while decision != "N"
      p "Would you like to place a flag? (Y/N)"
      decision = gets.chomp.upcase
      if decision == "Y"
        p "Choose the tile you would like to flag (y,x)"
        pos = gets.chomp.split(',').map do |num|
          num.to_i
        end
        @grid[pos].flag
      end
    end

   p "Choose the tile you would like to reveal (y,x)"
   pos = gets.chomp.split(',').map do |num|
     num.to_i
   end

  end
end

class Grid

  attr_accessor :lost, :won

  def initialize(game, size = "S", difficulty = 1)
    @game, @size, @difficulty = game, size.upcase, difficulty
    @side_length = get_side_length(@size)
    @board = self.build_grid
  end

  def get_side_length(size)
    case @size
      when "S"
        8
      when "M"
        12
      when "L"
        16
    end
  end

  def build_grid
    # difficulty = 1, 2, or 3
    board = []
    @side_length.times do |row|
      @side_length.times do |col|
        if rand(10) <= @difficulty
          bomb = true
        else
          bomb = false
        end

        tile = Tile.new(self, [row, col], bomb)
        board << tile
      end
    end
    board
  end

  def show
    line_break = @side_length

    @board.each_with_index do |tile, idx|
      print "[" + tile.symbol.to_s + "]"
      puts nil if (idx + 1) % line_break   == 0
    end
    nil
  end

  def blowup!
  end

  def all_reveal!
  end

  def [](pos)
    @board.find { |tile| tile.pos == pos }
  end

  def over?
    lost || won?
  end

  def lost_board
    self.lost = true
  end

  def won?
    non_bomb_spaces = @board.select { |tile| !tile.bomb }
    non_bomb_spaces.all? { |tile| tile.revealed? }
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
    if self.symbol == " " || self.symbol == "F"
      self.symbol = ( @flagged ? "F" : " ")
    end
  end

  def revealed?
    @revealed
  end

  def reveal!
    return if self.revealed?
    @revealed = true
    if self.bomb
      grid.blowup!
      self.symbol = "B"
      p "there was a bomb here"
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
