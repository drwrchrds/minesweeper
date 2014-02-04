require 'yaml'

class SaveFile
  def initialize(file_name)
    @file_name = file_name
  end

  def save_game(grid)
    game_state = grid.to_yaml
    File.open("#{Time.now}_#{@file_name}_saved_game.txt", "w") do |line|
      line.puts game_state
    end
    p "Game saved"
  end

  def self.load

  end
end