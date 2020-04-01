# require_relative 'turn'
class Game
  attr_reader :user_input

  def initialize
    @user_input = nil
    @computers_board = Board.new
    @user_board = Board.new
    @user_cruiser = Ship.new("Cruiser", 3)
    @user_submarine = Ship.new("Submarine", 2)
    @computer_cruiser = Ship.new("Cruiser", 3)
    @computer_submarine = Ship.new("Submarine", 2)
  end

  def q_anywhere_quit_game
    if @user_input.include?("q" || "quit")
      end_game
    end
  end

  def user_input_start
    gets.chomp
    #.downcase
  end

  def game_start
    p "Main Menu:"
    p "Welcome to BATTLESHIP"
    p "Enter p to play. Enter q to quit."
    @user_input = user_input_start
    if @user_input == "p"
      computer_place_cruiser
      # play_game #this method is pending!!!!!!!!!!!
    elsif @user_input == "q"
      end_game
    else
      p "Enter p to play. Enter q to quit."
      @user_input = user_input_start
    end
  end

  def player_place_message_cruiser
    p "I have laid out my ships on the grid."
    p "You now need to lay out your two ships."
    p "The Cruiser is three units long and the Submarine is two units long."
    puts @user_board.render
    p "Enter the squares for the Cruiser (3 spaces):"
    player_cruise_placement
  end

  def player_cruise_placement
    cruiser_cell_a = gets.chomp
    cruiser_cell_b = gets.chomp
    cruiser_cell_c = gets.chomp
    cruiser_hopeful_placement = [cruiser_cell_a, cruiser_cell_b, cruiser_cell_c]

    @user_input = cruiser_hopeful_placement
    q_anywhere_quit_game
    validating_coordinates(cruiser_hopeful_placement)
  end


  def validating_coordinates(cruiser_hopeful_coordinates)
    coordinates_are_valid = cruiser_hopeful_coordinates.all? do |placement|
      @user_board.valid_coordinate?(placement)
    end
      if !coordinates_are_valid
        puts "Those are invalid coordinates. Please try again:"
        player_cruise_placement
      else
        validating_placement(cruiser_hopeful_coordinates)
      end
  end

  def validating_placement(cruiser_hopeful_placement)
    placements_are_valid = @user_board.valid_placement?(@user_cruiser, cruiser_hopeful_placement)

    if !placements_are_valid
      puts "Those are invalid coordinates. Please try again:"
      player_cruise_placement
    elsif placements_are_valid && @user_board.valid_placement?(@user_cruiser, cruiser_hopeful_placement)
      place_ship(@user_cruiser, cruiser_hopeful_placement)
    end
  end


  def place_ship(ship, cruiser_hopeful_placement)
    @user_board.place(@user_cruiser, cruiser_hopeful_placement)
      puts @user_board.render(true)
    player_submarine_placement
  end
######
  def player_submarine_placement
    p "Enter the squares for the Submarine (2 spaces):"
    submarine_cell_a = gets.chomp
    submarine_cell_b = gets.chomp
    submarine_hopeful_coordinates = [submarine_cell_a, submarine_cell_b]

    @user_input = submarine_hopeful_coordinates
    q_anywhere_quit_game
    validating_coordinates_submarine(submarine_hopeful_coordinates)
  end
    ####
  def validating_coordinates_submarine(submarine_hopeful_coordinates)
    coordinates_are_valid =submarine_hopeful_coordinates.all? do |placement|
      @user_board.valid_coordinate?(placement)
    end
      if !coordinates_are_valid
        puts "Those are invalid coordinates. Please try again:"
        player_submarine_placement
      else
        validating_placement_submarine(submarine_hopeful_coordinates)
      end
  end

  def validating_placement_submarine(submarine_hopeful_coordinates)
    placements_are_valid = @user_board.valid_placement?(@user_submarine, submarine_hopeful_coordinates)

    if !placements_are_valid
      puts "Those are invalid coordinates. Please try again:"
      player_submarine_placement
    elsif placements_are_valid && @user_board.valid_placement?(@user_submarine, submarine_hopeful_coordinates)
      place_submarine(@user_submarine, submarine_hopeful_coordinates)
    end
  end


  def place_submarine(ship, submarine_hopeful_placement)
    @user_board.place(@user_submarine, submarine_hopeful_placement)
      puts @user_board.render(true)
    turn_start
  end
  #####
    # coordinates_are_valid = submarine_hopeful_placement.all? do |placement|
    #   @user_board.valid_coordinate?(placement)
    # end
    # if  !coordinates_are_valid
    #     puts "Those are invalid coordinates. Please try again:"
    #     player_submarine_placement
    # end

    # placements_are_valid = @user_board.valid_placement?(@user_submarine, submarine_hopeful_placement)
    #
    # if !placements_are_valid || !coordinates_are_valid
    #    puts "Those are invalid coordinates. Please try again:"
    #    player_submarine_placement
    # elsif placements_are_valid && @user_board.valid_placement?(@user_submarine, submarine_hopeful_placement)
    #   @user_board.place(@user_submarine, submarine_hopeful_placement)
    # end
    # puts @user_board.render(true)
    # turn_start



  def computer_place_cruiser
      possible_coordinates_cruiser = [['A1', 'A2', 'A3'], ['A2','A3','A4'], ['B1', 'B2', 'B3'], ['B2','B3','B4'], ['C1', 'C2', 'C3'], ['C2','C3','C4'], ['D1', 'D2', 'D3'], ['D2','D3','D4'], ['A1', 'B1', 'C1'], ['A2', 'B2', 'C2'], ['A3', 'B3', 'C3'], ['A4', 'B4', 'C4'], ['B1', 'C1', 'D1'], ['B2', 'C2', 'D2'], ['B3', 'C3', 'D3'], ['B4', 'C4', 'D4']]
    if @computers_board.overlap?(possible_coordinates_cruiser.sample) == false
      @computers_board.place(@computer_cruiser, possible_coordinates_cruiser.sample)
    end
    @computers_board.render
    computer_place_sub
  end

  def computer_place_sub
    possible_coordinates_sub = [['A1', 'A2'], ['B1', 'B2'], ['C1', 'C2'], ['D1', 'D2'], ['A2', 'A3'], ['B2', 'B3'], ['C2', 'C3'], ['D2', 'D3'], ['A3', 'A4'], ['B3', 'B4'], ['C3', 'C4'], ['D3', 'D4'], ['A1', 'B1'], ['B1', 'C1'], ['C1', 'D1'], ['A2', 'B2'], ['B2', 'C2'], ['C2', 'D2'], ['A3', 'B3'], ['B3', 'C3'], ['C3', 'D3'], ['A4', 'B4'], ['B4', 'C4'], ['C4', 'D4']]
    if @computers_board.valid_coordinate?(possible_coordinates_sub.sample) == false
      @computers_board.place(@computer_submarine, possible_coordinates_sub.sample)
    end
    @computers_board.render
    player_place_message_cruiser
  end


  def render_boards_for_turn
    puts @computers_board.render
    puts @user_board.render(true)
    player_shot
  end

  def player_shot
    p 'Enter the coordinate for your shot:'
    @user_input = gets.chomp.upcase
    q_anywhere_quit_game
    if @user_input
    end

    #if user_shot
    #where we left off last night!!
  end

  def turn_start
    puts "=============COMPUTER BOARD============="
    puts @computers_board.render
    puts "==============PLAYER BOARD=============="
    puts @user_board.render(true)
    player_shot
  end

  def turn
    while @user_submarine.sunk? && @user_cruiser.sunk? == false || @computer_submarine.sunk? && @computer_cruiser.sunk? == false
      render_boards_for_turn
    end
  end


  def end_game

    puts "Game over..."
    puts ".."
    sleep (1)
    puts "bye felicia"
    game_start
  end
end
