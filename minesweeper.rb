require 'colorize'
require 'yaml'
require 'json'
require_relative 'Tiles'
require_relative 'Grid'

class Game

  attr_reader :grid, :lapsed_time

  def initialize(load = false)
    @load = load
    @leader_board = load_leader_board if Dir.entries(".").include?("leader_board.txt")
    if load
      @grid = load_game_file
      @grid.game = self
    else
      @grid = Grid.new(self)
    end
    self.play
  end

  def play
    start_time = Time.now
    until @grid.over?
      @grid.show
      pos = play_turn
      @grid[pos].reveal!
      self.save_game
    end

    if @grid.won?
      end_time = Time.now
      @lapsed_time = start_time - end_time
      @grid.all_reveal!
      p "You found all the bombs - you took #{lapsed_time}"
      check_leader_board
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

      yaml_save(game_name)
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
  def check_leader_board
    replace = 0
    init = nil

    @leader_board.each_with_index do |leader, idx|
      if leader[0] > @lapsed_time
        p "You have earned the #{idx+1} spot on the leader board"
        p "please enter your initals!"
        init = gets.chomp
        replace = idx
        break
      end
    end

    if replace
      @leader_board.insert(replace, [@lapsed_time, init, Time.date, @grid.difficulty])
      save_leader_board
    end
  end

  def save_leader_board
    File.open("leader_board.txt", "w") do |line|
      @leader_board.take(10).each do |leader|
        p leader
        line.puts leader.to_json
      end
    end
  end

  def load_leader_board
    leader_board = []
     File.open("leader_board.txt").each  do |line|
      leader_board << JSON.parse(line)
    end
    leader_board
  end

  def yaml_save(file_name)
    game_state = @grid.to_yaml
    File.open("#{file_name}_save.txt", "w") do |line|
      line.puts game_state
    end
    p "Game saved!"
  end

  def yaml_load
    p "what is the name of the game file"
    file_name = gets.chomp
    YAML::load(File.open(file_name))
  end


end



