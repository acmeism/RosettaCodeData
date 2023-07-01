# 21 Game - an example in Ruby for Rosetta Code.

GOAL = 21
MIN_MOVE = 1
MAX_MOVE = 3

DESCRIPTION = "
*** Welcome to the 21 Game! ***
21 is a two player game.
Each player chooses to add 1, 2 or 3 to a running total.
The player whose turn it is when the total reaches 21 will win the game.
The running total starts at zero.

The players start the game in turn.
Enter q to quit at any time.
"

#
# Returns the best move to play.
#
def best_move(total)
  move = rand(1..3)
  MIN_MOVE.upto(MAX_MOVE) do |i|
    move = i if (total + i - 1) % (MAX_MOVE + 1) == 0
  end
  MIN_MOVE.upto(MAX_MOVE) do |i|
    move = i if total + i == GOAL
  end
  move
end

#
# Gets the move of the player.
#
def get_move
  print "Your choice between #{MIN_MOVE} and #{MAX_MOVE}: "
  answer = gets
  move = answer.to_i
  until move.between?(MIN_MOVE, MAX_MOVE)
    exit if answer.chomp == 'q'
    print 'Invalid choice. Try again: '
    answer = gets
    move = answer.to_i
  end
  move
end

#
# Asks the player to restart a game and returns the answer.
#
def restart?
  print 'Do you want to restart (y/n)? '
  restart = gets.chomp
  until ['y', 'n'].include?(restart)
    print 'Your answer is not a valid choice. Try again: '
    restart = gets.chomp
  end
  restart == 'y'
end

#
# Run a game. The +player+ argument is the player that starts:
# * 1 for human
# * 0 for computer
#
def game(player)
  total = round = 0
  while total < GOAL
    round += 1
    puts "--- ROUND #{round} ---\n\n"
    player = (player + 1) % 2
    if player == 0
      move = best_move(total)
      puts "The computer chooses #{move}."
    else
      move = get_move
    end
    total += move
    puts "Running total is now #{total}.\n\n"
  end
  if player == 0
    puts 'Sorry, the computer has won!'
    return false
  end
  puts 'Well done, you have won!'
  true
end

# MAIN
puts DESCRIPTION
run = true
computer_wins = human_wins = 0
games_counter = player = 1
while run
  puts "\n=== START GAME #{games_counter} ==="
  player = (player + 1) % 2
  if game(player)
    human_wins += 1
  else
    computer_wins += 1
  end
  puts "\nComputer wins #{computer_wins} games, you wins #{human_wins} game."
  games_counter += 1
  run = restart?
end
puts 'Good bye!'
