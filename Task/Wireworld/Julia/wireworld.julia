function surround2D(b, i, j)
    h, w = size(b)
    [b[x,y] for x in i-1:i+1, y in j-1:j+1 if (0 < x <= h && 0 < y <= w)]
end

surroundhas1or2(b, i, j) = 0 < sum(map(x->Char(x)=='H', surround2D(b, i, j))) <= 2 ? 'H' : '.'

function boardstep!(currentboard, nextboard)
    x, y = size(currentboard)
    for j in 1:y, i in 1:x
        ch = Char(currentboard[i, j])
        if ch == ' '
            continue
        else
            nextboard[i, j] = (ch == 'H') ? 't' : (ch == 't' ? '.' :
                   surroundhas1or2(currentboard, i, j))
        end
    end
end

const b1 = "         " *
           "  tH     " *
           " .  .... " *
           "  ..     " *
           "         "
const mat = reshape(map(x->UInt8(x[1]), split(b1, "")), (9, 5))'
const mat2 = copy(mat)

function printboard(mat)
    for i in 1:size(mat)[1]
        println("\t", join([Char(c) for c in mat[i,:]], ""))
    end
end

println("Starting Wireworld board:")
printboard(mat)
for step in 1:8
    boardstep!(mat, mat2)
    println(" Step $step:")
    printboard(mat2)
    mat .= mat2
end
