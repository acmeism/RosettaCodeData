const whitepieces = "♖♘♗♕♔♗♘♖♙"
const whitechars = "rnbqkp"
const blackpieces = "♜♞♝♛♚♝♞♜♟"
const blackchars = "RNBQKP"
const piece2ascii = Dict(zip("♖♘♗♕♔♗♘♖♙♜♞♝♛♚♝♞♜♟", "rnbqkbnrpRNBQKBNRP"))

""" Derive a chess960 position's SP-ID from its string representation. """
function chess960spid(position::String = "♖♘♗♕♔♗♘♖", errorchecking = true)
    if errorchecking
        @assert length(position) == 8 "Need exactly 8 pieces"
        @assert all(p -> p in whitepieces || p in blackpieces, position) "Invalid piece character"
        @assert all(p -> p in whitepieces, position) || all(p -> p in blackpieces, position) "Side of pieces is mixed"
        @assert all(p -> !(p in "♙♟"), position) "No pawns allowed"
    end
    a = uppercase(String([piece2ascii[c] for c in position]))

    if errorchecking
        @assert all(p -> count(x -> x == p, a) == 1, "KQ") "Need exactly one of each K and Q"
        @assert all(p -> count(x -> x == p, a) == 2, "RNB") "Need exactly 2 of each R, N, B"
        @assert findfirst(p -> p == 'R', a) < findfirst(p -> p == 'K', a) < findlast(p -> p == 'R', a) "King must be between rooks"
        @assert isodd(findfirst(p -> p == 'B', a) + findlast(p -> p == 'B', a)) "Bishops must be on different colors"
    end

    knighttable = [12, 13, 14, 15, 23, 24, 25, 34, 35, 45]
    noQB = replace(a, r"[QB]" => "")
    knightpos1, knightpos2 = findfirst(c -> c =='N', noQB), findlast(c -> c =='N', noQB)
    N = findfirst(s -> s == 10 * knightpos1 + knightpos2, knighttable) - 1
    Q = findfirst(c -> c == 'Q', replace(a, "B" => "")) - 1
    bishoppositions = [findfirst(c -> c =='B', a), findlast(c -> c =='B', a)]
    if isodd(bishoppositions[2])
        bishoppositions = reverse(bishoppositions) # dark color bishop first
    end
    D, L = bishoppositions[1] ÷ 2, bishoppositions[2] ÷ 2 - 1

    return 96N + 16Q + 4D + L
end

for position in ["♕♘♖♗♗♘♔♖", "♖♘♗♕♔♗♘♖", "♖♕♘♗♗♔♖♘", "♖♘♕♗♗♔♖♘"]
    println(collect(position), " => ", chess960spid(position))
end
