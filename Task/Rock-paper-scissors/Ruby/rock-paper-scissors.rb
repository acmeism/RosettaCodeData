class RockPaperScissorsGame
  CHOICES = %w[rock paper scissors quit]
  BEATS = {
    'rock'     => 'paper',
    'paper'    => 'scissors',
    'scissors' => 'rock',
  }

  def initialize()
    @plays = {
      'rock'     => 1,
      'paper'    => 1,
      'scissors' => 1,
    }
    @score = [0, 0, 0]          # [0]:Human wins, [1]:Computer wins, [2]:draw

    play
  end

  def humanPlay
    loop do
      print "\nYour choice: #{CHOICES}? "
      answer = STDIN.gets.strip.downcase
      next if answer.empty?
      idx = CHOICES.find_index {|choice| choice.match(/^#{answer}/)}
      return CHOICES[idx] if idx
      puts "invalid answer, try again"
    end
  end

  def computerPlay
    total = @plays.values.reduce(:+)
    r = rand(total) + 1
    sum = 0
    CHOICES.each do |choice|
      sum += @plays[choice]
      return BEATS[choice] if r <= sum
    end
  end

  def play
    loop do
      h = humanPlay
      break if h == "quit"
      c = computerPlay
      print "H: #{h}, C: #{c} => "

      # only update the human player's history after the computer has chosen
      @plays[h] += 1

      if h == c
        puts "draw"
        @score[2] += 1
      elsif h == BEATS[c]
        puts "Human wins"
        @score[0] += 1
      else
        puts "Computer wins"
        @score[1] += 1
      end
      puts "score: human=%d, computer=%d, draw=%d" % [*@score]
    end
    @plays.each_key{|k| @plays[k] -= 1}
    puts "\nhumans chose #{@plays}"
  end
end

RockPaperScissorsGame.new
