require 'colorize'
require 'yaml'
require_relative 'Tiles'
require_relative 'Grid'
require_relative 'save_game.rb'

class Game

  attr_reader :grid

  def initialize(load = false)
    @load = load
    if load
      @grid = load_game_file.grid
      @grid.game = self
    else
      @grid = Grid.new(self)
    end
    self.play
  end

  def play
    until @grid.over?
      @grid.show
      pos = play_turn
      @grid[pos].reveal!
      self.save_game
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

  def save_game
    p "Would you like to save the game? (Y/N)"
    input = gets.chomp.upcase
    if input == "Y"
      p "What would you like to call this game?"
      game_name = gets.chomp

      save_game_file(game_name)
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
        @grid[pos].flagged = ( @grid[pos].flagged ? false : true )
        @grid.show
      end
    end

   p "Choose the tile you would like to reveal (y,x)"
   pos = gets.chomp.split(',').map do |num|
     num.to_i
   end

  end
  def save_game_file(file_name)
    game_state = @grid.to_yaml
    File.open("#{Time.now}_#{file_name}_saved_game.txt", "w") do |line|
      line.puts game_state
    end
    p "Game saved"
  end

  def load_game_file
    p "what is the name of the game file"
    file_name = gets.chomp
    yaml_object = File.open(file_name)
    game = YAML::load(yaml_object)
  end
end



