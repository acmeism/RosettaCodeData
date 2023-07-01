class Position
    attr_reader :x, :y

    def initialize(x, y)
        @x = x
        @y = y
    end

    def ==(other)
        self.x == other.x &&
        self.y == other.y
    end

    def to_s
        '(%d, %d)' % [@x, @y]
    end

    def to_str
        to_s
    end
end

def isAttacking(queen, pos)
    return queen.x == pos.x ||
           queen.y == pos.y ||
           (queen.x - pos.x).abs() == (queen.y - pos.y).abs()
end

def place(m, n, blackQueens, whiteQueens)
    if m == 0 then
        return true
    end
    placingBlack = true
    for i in 0 .. n-1
        for j in 0 .. n-1
            catch :inner do
                pos = Position.new(i, j)
                for queen in blackQueens
                    if pos == queen || !placingBlack && isAttacking(queen, pos) then
                        throw :inner
                    end
                end
                for queen in whiteQueens
                    if pos == queen || placingBlack && isAttacking(queen, pos) then
                        throw :inner
                    end
                end
                if placingBlack then
                    blackQueens << pos
                    placingBlack = false
                else
                    whiteQueens << pos
                    if place(m - 1, n, blackQueens, whiteQueens) then
                        return true
                    end
                    blackQueens.pop
                    whiteQueens.pop
                    placingBlack = true
                end
            end
        end
    end
    if !placingBlack then
        blackQueens.pop
    end
    return false
end

def printBoard(n, blackQueens, whiteQueens)
    # initialize the board
    board = Array.new(n) { Array.new(n) { ' ' } }
    for i in 0 .. n-1
        for j in 0 .. n-1
            if i % 2 == j % 2 then
                board[i][j] = '•'
            else
                board[i][j] = '◦'
            end
        end
    end

    # insert the queens
    for queen in blackQueens
        board[queen.y][queen.x] = 'B'
    end
    for queen in whiteQueens
        board[queen.y][queen.x] = 'W'
    end

    # print the board
    for row in board
        for cell in row
            print cell, ' '
        end
        print "\n"
    end
    print "\n"
end

nms = [
    [2, 1],
    [3, 1], [3, 2],
    [4, 1], [4, 2], [4, 3],
    [5, 1], [5, 2], [5, 3], [5, 4], [5, 5],
    [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6],
    [7, 1], [7, 2], [7, 3], [7, 4], [7, 5], [7, 6], [7, 7]
]
for nm in nms
    m = nm[1]
    n = nm[0]
    print "%d black and %d white queens on a %d x %d board:\n" % [m, m, n, n]

    blackQueens = []
    whiteQueens = []
    if place(m, n, blackQueens, whiteQueens) then
        printBoard(n, blackQueens, whiteQueens)
    else
        print "No solution exists.\n\n"
    end
end
