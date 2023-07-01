# conventional weapons
enum Choice
  Rock
  Paper
  Scissors
end

BEATS = {
  Choice::Rock     => [Choice::Paper],
  Choice::Paper    => [Choice::Scissors],
  Choice::Scissors => [Choice::Rock],
}

# uncomment to use additional weapons
# enum Choice
#   Rock
#   Paper
#   Scissors
#   Lizard
#   Spock
# end

# BEATS = {
#   Choice::Rock     => [Choice::Paper, Choice::Spock],
#   Choice::Paper    => [Choice::Scissors, Choice::Lizard],
#   Choice::Scissors => [Choice::Rock, Choice::Spock],
#   Choice::Lizard   => [Choice::Rock, Choice::Scissors],
#   Choice::Spock    => [Choice::Paper, Choice::Lizard],
# }

class RPSAI
  @stats = {} of Choice => Int32

  def initialize
    Choice.values.each do |c|
      @stats[c] = 1
    end
  end

  def choose
    v = rand(@stats.values.sum)
    @stats.each do |choice, rate|
      v -= rate
      return choice if v < 0
    end
    raise ""
  end

  def train(selected)
    BEATS[selected].each do |c|
      @stats[c] += 1
    end
  end
end

enum GameResult
  HumanWin
  ComputerWin
  Draw

  def to_s
    case self
    when .draw?
      "Draw"
    when .human_win?
      "You win!"
    when .computer_win?
      "I win!"
    end
  end
end

class RPSGame
  @score = Hash(GameResult, Int32).new(0)
  @ai = RPSAI.new

  def check(player, computer)
    return GameResult::ComputerWin if BEATS[player].includes? computer
    return GameResult::HumanWin if BEATS[computer].includes? player
    return GameResult::Draw
  end

  def round
    puts ""
    print "Your choice (#{Choice.values.join(", ")}):"
    s = gets.not_nil!.strip.downcase
    return false if "quit".starts_with? s
    player_turn = Choice.values.find { |choice| choice.to_s.downcase.starts_with? s }
    unless player_turn
      puts "Invalid choice"
      return true
    end
    ai_turn = @ai.choose
    result = check(player_turn, ai_turn)
    puts "H: #{player_turn}, C: #{ai_turn} => #{result}"
    @score[result] += 1
    puts "score: human=%d, computer=%d, draw=%d" % GameResult.values.map { |r| @score[r] }
    @ai.train player_turn
    true
  end
end

game = RPSGame.new
loop do
  break unless game.round
end
