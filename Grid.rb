class Grid

  attr_accessor :lost, :won, :game

  def initialize(game, size = "S", difficulty = 4)
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
    board = []
    @side_length.times do |row|
      @side_length.times do |col|
        bomb = ( rand(10) <= @difficulty )

        tile = Tile.new(self, [row, col], bomb)
        board << tile
      end
    end
    board
  end

  def show(wait = 0)
    line_break = @side_length

    @board.each_with_index do |tile, idx|
      if tile.flagged
        symbol = "F".white
      else
        if tile.bomb
          if self.over?
            symbol = "B".red.blink
          else
            # p tile.flagged
            symbol = " "
          end
        else
          symbol = tile.symbol.to_s.magenta
        end
      end
      print "[" + symbol + "]"
      puts nil if (idx + 1) % line_break == 0
      sleep(wait)
    end
    nil
  end

  def blowup!
    self.show(0.03)
  end

  def all_reveal!
    self.show(0.03)
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