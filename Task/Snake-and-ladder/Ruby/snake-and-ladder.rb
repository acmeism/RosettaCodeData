NONE = 0; LADDER = 1; SNAKE = 2; STAY = 1; MOVE = 2; WIN = 3
class Cell
    @type; @to; attr_reader :type, :to
    def initialize; @type = NONE; @to = 0; end
    def set( t, o ); @type = t; @to = o; end
end
class Player
    @pos; @name; attr_accessor :pos; attr_reader :name
    def initialize( n ); @pos = 0; @name = n; end
    def play( dice )
        s = dice.roll; return s, STAY if @pos + s > 99
        @pos += s; return s, WIN if @pos == 99
        return s, MOVE
    end
end
class Die
    @sides; def initialize( s = 6 ); @sides = s; end
    def roll; return 1 + rand( @sides ); end
end
def initBoard
    @board = Array.new( 100 ); for i in 0 .. 99; @board[i] = Cell.new(); end
    @board[3].set( LADDER, 13 ); @board[8].set( LADDER, 30 ); @board[19].set( LADDER, 37 );
    @board[27].set( LADDER, 83 );@board[39].set( LADDER, 58 ); @board[50].set( LADDER, 66 );
    @board[62].set( LADDER, 80 ); @board[70].set( LADDER, 90 ); @board[16].set( SNAKE, 6 );
    @board[61].set( SNAKE, 18 ); @board[86].set( SNAKE, 23 ); @board[53].set( SNAKE, 33 );
    @board[63].set( SNAKE, 59 ); @board[92].set( SNAKE, 72 ); @board[94].set( SNAKE, 74 );
    @board[98].set( SNAKE, 77 );
end
def initPlayers
    @players = Array.new( 4 );
    for i in 0 .. @playersCount - 1; @players[i] = Player.new( "player " << i + 49 ); end
end
def play
    initBoard; initPlayers; @die = Die.new
    while true
        for p in 0 .. @playersCount - 1
            puts; puts
            if( 0 == p )
                print "#{@players[p].name}, your turn. Your position is cell #{@players[p].pos + 1}.\n"<<
                "Press [RETURN] to roll the die."
                gets; np = @players[p].play( @die ); print "You rolled a #{np[0]}\n"
                if np[1] == WIN
                    print "You reached position #{@players[p].pos + 1} and win the game!!!!\n"; return
                elsif np[1] == STAY; print "Sorry, you cannot move!\n"
                else print "Your new position is cell #{@players[p].pos + 1}.\n";
                end
            else
                np = @players[p].play( @die ); print "#{@players[p].name} rolled a #{np[0]}.\n"
                if np[1] == WIN
                     print "He reached position #{@players[p].pos + 1} and wins the game!!!!\n"; return
                elsif np[1] == STAY; print "But he cannot move....\n"
                else print "His new position is cell #{@players[p].pos + 1}.\n";
                end
            end
            s = @board[@players[p].pos].type
            next if s == NONE
            @players[p].pos = @board[@players[p].pos].to
            case s
                when SNAKE; print "What a pitty, landed on a snake. "
                when LADDER; print "Lucky move! Landed on a ladder. "
            end
            print "New position is cell #{@players[p].pos + 1}.\n"
        end
    end
end
@playersCount = 4; @board; @players; @die
play
