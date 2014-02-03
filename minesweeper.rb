require 'colorize'
require_relative 'Tiles'
require_relative 'Grid'

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
    nil
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
        @grid.show
      end
    end

   p "Choose the tile you would like to reveal (y,x)"
   pos = gets.chomp.split(',').map do |num|
     num.to_i
   end

  end
end



