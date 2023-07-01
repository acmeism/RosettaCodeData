def hasNK(board, a, b)
    (-1..1).each do |g|
        (-1..1).each do |f|
            aa = a + f; bb = b + g
            if (0..7).includes?(aa) && (0..7).includes?(bb)
                p = board[aa + 8 * bb]
                return true if p == "K" || p == "k"
            end
        end
    end
    return false
end

def generateBoard(board, pieces)
    pieces.each_char do |p|
        while true
            a = rand(8); b = rand(8)
            next  if ( (b == 0 || b == 7) && (p == "P" || p == "p") ) ||
               ( (p == "k" || p == "K") && hasNK(board, a, b) )
            break if board[a + b * 8] == '.'
        end
        board[a + b * 8] = p
    end
end

pieces = "ppppppppkqrrbbnnPPPPPPPPKQRRBBNN"
11.times do
    e = pieces.size - 1
    while e > 0
        p = rand(e); t = pieces[e]
        #pieces[e] = pieces[p]; pieces[p] = t; e -= 1 # in Ruby
        pieces = pieces.sub(e, pieces[p])             # in Crystal because
        pieces = pieces.sub(p, t); e -= 1             # strings immutable
    end
end

# No 'nil' for Crystal arrays; use '.' for blank value
board = Array.new(64, '.'); generateBoard(board, pieces)
puts
e = 0
8.times do |j| row_j = j * 8
    8.times do |i|
        board[row_j + i ] == '.' ? (e += 1) :
            ( (print(e); e = 0) if e > 0
            print board[row_j + i] )
    end
    (print(e); e = 0) if e > 0
    print("/") if j < 7
end

print(" w - - 0 1\n")
8.times do |j| row_j = j * 8
  8.times { |i| board[row_j + i] == '.' ? print(".") : print(board[row_j + i]) }
  puts
end

# Simpler for same output
8.times{ |row| puts board[row*8..row*8 + 7].join("") }
