def hasNK( board, a, b )
    for g in -1 .. 1
        for f in -1 .. 1
            aa = a + f; bb = b + g
            if aa.between?( 0, 7 ) && bb.between?( 0, 7 )
                p = board[aa + 8 * bb]
                if p == "K" || p == "k"; return true; end
            end
        end
    end
    return false
end
def generateBoard(  board, pieces  )
    while( pieces.length > 1 )
        p = pieces[pieces.length - 1]
        pieces = pieces[0...-1]
        while( true )
            a = rand( 8 ); b = rand( 8 )
            if ( ( b == 0 || b == 7 ) && ( p == "P" || p == "p" ) ) ||
               ( ( p == "k" || p == "K" ) && hasNK( board, a, b ) ); next; end
            if board[a + b * 8] == nil; break;end
        end
        board[a + b * 8] = p
    end
end
pieces = "ppppppppkqrrbbnnPPPPPPPPKQRRBBNN"
for i in 0 .. 10
    e = pieces.length - 1
    while e > 0
        p = rand( e ); t = pieces[e];
        pieces[e] = pieces[p]; pieces[p] = t; e -= 1
    end
end
board = Array.new( 64 ); generateBoard( board, pieces )
puts
e = 0
for j in 0 .. 7
    for i in 0 .. 7
        if board[i + 8 * j] == nil; e += 1
        else
            if e > 0; print( e ); e = 0; end
            print( board[i + 8 * j] )
        end
    end
    if e > 0; print( e ); e = 0; end
    if j < 7; print( "/" ); end
end
print( " w - - 0 1\n" )
for j in 0 .. 7
    for i in 0 .. 7
        if board[i + j * 8] == nil; print( "." )
        else print( board[i + j * 8] ); end
    end
    puts
end
