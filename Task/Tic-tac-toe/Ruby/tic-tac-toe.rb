module TicTacToe

  class Game
    def initialize(player1Class, player2Class)
      @board = Array.new(10)
      @free_positions = (1..9).to_a
      @players = [player1Class.new(self), player2Class.new(self)]
      @turn = rand(2)
      puts "#{@players[@turn]} goes first."
      @players[@turn].marker = "X"
      @players[nextTurn].marker = "O"
      @winning_rows = [[1,2,3],[4,5,6],[7,8,9],[1,4,7],[2,5,8],[3,6,9],[1,5,9],[3,5,7]]
    end
    attr_reader :free_positions, :winning_rows, :board

    def play
      loop do
        player = @players[@turn]
        idx = player.select
        puts "#{player} selects #{player.marker} position #{idx}"
        @board[idx] = player.marker
        @free_positions.delete(idx)

        # check for a winner
        @winning_rows.each do |row|
          if row.all? {|idx| @board[idx] == player.marker}
            puts "#{player} wins!"
            print
            return
          end
        end

        # no winner, is board full?
        if @free_positions.empty?
          puts "It's a draw."
          print
          return
        end

        nextTurn!
      end
    end

    def nextTurn
      (@turn + 1) % 2
    end

    def nextTurn!
      @turn = nextTurn
    end

    def opponent
      @players[nextTurn]
    end

    def print
      puts [1,2,3].map {|i| @board[i].nil? ? i : @board[i]}.join("|")
      puts "-+-+-"
      puts [4,5,6].map {|i| @board[i].nil? ? i : @board[i]}.join("|")
      puts "-+-+-"
      puts [7,8,9].map {|i| @board[i].nil? ? i : @board[i]}.join("|")
    end
  end

  class Player
    def initialize(game)
      @game = game
      @marker = nil
    end
    attr_accessor :marker
  end

  class HumanPlayer < Player
    def initialize(game)
      super(game)
    end

    def select
      @game.print
      loop do
        print "Select your #{marker} position: "
        selection = $stdin.gets.to_i
        if not @game.free_positions.include?(selection)
          puts "Position #{selection} is not available. Try again."
          next
        end
        return selection
      end
    end

    def to_s
      "Human"
    end
  end

  class ComputerPlayer < Player
    def initialize(game)
      super(game)
    end

    def group_row(row, opponent)
      markers = {self.marker => [], opponent.marker => [], nil => []} .
                merge(row.group_by {|idx| @game.board[idx]})
      #p [row, markers].inspect
      markers
    end

    def select
      index = nil
      opponent = @game.opponent

      # look for winning rows
      @game.winning_rows.each do |row|
        markers = group_row(row, opponent)
        if markers[self.marker].length == 2 and markers[nil].length == 1
          return markers[nil].first
        end
      end

      # look for opponent's winning rows to block
      @game.winning_rows.each do |row|
        markers = group_row(row, opponent)
        if markers[opponent.marker].length == 2 and markers[nil].length == 1
          return markers[nil].first
        end
      end

      # need some logic here to get the computer to pick a smarter position

      # simply pick a position in order of preference
      [5].concat([1,3,7,9].shuffle).concat([2,4,6,8].shuffle).each do |pos|
        return pos if @game.free_positions.include?(pos)
      end
    end

    def to_s
      "Computer"
    end
  end
end

TicTacToe::Game.new(TicTacToe::ComputerPlayer, TicTacToe::ComputerPlayer).play
TicTacToe::Game.new(TicTacToe::HumanPlayer,    TicTacToe::ComputerPlayer).play
