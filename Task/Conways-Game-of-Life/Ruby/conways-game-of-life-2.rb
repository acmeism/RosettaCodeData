class Game
    def initialize(name, size, generations, initial_life=nil)
        @board = GameBoard.new size, initial_life
        @board.display 0, name

        reason = generations.times do |gen|
            new_board = evolve
            new_board.display gen+1, name
            break :all_dead if new_board.barren?
            break :static   if @board == new_board
            @board = new_board
        end

        if reason == :all_dead then puts "No more life."
        elsif reason == :static then puts "No movement."
        else puts "Specified lifetime ended."
        end
    end

    def evolve
        new_board = GameBoard.new @board.size, @board.life
        @board.size.times do |i|
            @board.size.times do |j|
                if cell_fate i, j
                    new_board[i,j].live
                else
                    new_board[i,j].die
                end
            end
        end
        new_board
    end

    def cell_fate(i, j)
        left = [0, i-1].max; right = [i+1, @board.size-1].min
        top = [0, j-1].max; bottom = [j+1, @board.size-1].min
        sum = 0
        for x in (left..right)
            for y in (top..bottom)
                sum += @board[x,y].value if (x != i or y != j)
            end
        end
        (sum == 3 or (sum == 2 and @board[i,j].alive?))
    end
end

class GameBoard
    attr_reader :size

    def initialize(size, initial_life=nil)
        @size = size
        @board = Array.new(size) {Array.new(size) {Cell.new false}}
        self.seed_board initial_life
    end

    def seed_board(life)
        if life.nil?
            # randomly seed board
            srand  # seed the random number generator
            indices = []
            @size.times {|x| @size.times {|y| indices << [x,y] }}
            indices.shuffle[0,10].each {|x,y| @board[y][x].live}
        else
            life.each {|x, y| @board[y][x].live}
        end
    end

    def [](x, y)
        @board[y][x]
    end

    def ==(board)
        self.life == board.life
    end

    def barren?
        @size.times do |i|
            @size.times do |j|
                return false if @board[i][j].alive?
            end
        end
        true
    end

    def life
        indices = []
        @size.times do |x|
            @size.times do |y|
                if @board[y][x].alive?
                    indices << [x,y]
                end
            end
        end
        indices
    end

    def display(generation, name)
        puts "#{name}: generation #{generation}"
        @board.each do |row|
            row.each do |cell|
                print "#{cell.alive? ? '#' : '.'} "
            end
            puts
        end
        puts
    end

    def apocalypse
        # utility function to entirely clear the game board
        @board.each do |row|
            row.each do |cell|
                if cell.alive?
                    cell.die
                end
            end
        end
    end
end

class Cell
    def initialize is_alive
        @is_alive = is_alive
    end

    def alive?
        @is_alive
    end

    def value
        if self.alive?
            return 1
        else
            return 0
        end
    end

    def live
        @is_alive = true
    end

    def die
        @is_alive = false
    end
end

game_of_life = Game.new "blinker", 3, 2, [[1,0],[1,1],[1,2]]
game_of_life = Game.new "glider", 4, 4, [[1,0],[2,1],[0,2],[1,2],[2,2]]
game_of_life = Game.new "random", 5, 10
