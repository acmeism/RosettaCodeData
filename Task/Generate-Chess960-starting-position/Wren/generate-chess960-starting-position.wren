import "random" for Random
import "./dynamic" for Tuple
import "./fmt" for Fmt

var Symbols = Tuple.create("Symbols", ["k", "q", "r", "b", "n"])

var A = Symbols.new("K", "Q", "R", "B", "N")
var W = Symbols.new("♔", "♕", "♖", "♗", "♘")
var B = Symbols.new("♚", "♛", "♜", "♝", "♞")

var krn = [
    "nnrkr", "nrnkr", "nrknr", "nrkrn",
    "rnnkr", "rnknr", "rnkrn",
    "rknnr", "rknrn",
    "rkrnn"
]

var NUL = "\0"

var chess960 = Fn.new { |sym, id|
    var pos = List.filled(8, NUL)
    var q = (id/4).floor
    var r = id % 4
    pos[r*2+1]= sym.b
    var t = q
    q = (q/4).floor
    r = t % 4
    pos[r*2] = sym.b
    t = q
    q = (q/6).floor
    r = t % 6
    var i = 0
    while (true) {
        if (pos[i] == NUL) {
            if (r == 0) {
                pos[i] = sym.q
                break
            }
            r = r - 1
        }
        i = i + 1
    }
    i = 0
    for (f in krn[q]) {
        while (pos[i] != NUL) i = i + 1
        pos[i] = (f == "k") ? sym.k :
                 (f == "r") ? sym.r :
                 (f == "n") ? sym.n : pos[i]
    }
    return pos.join(" ")
}

System.print(" ID  Start position")
for (id in [0, 518, 959]) Fmt.print("$3d  $s", id, chess960.call(A, id))
System.print("\nRandom")
var rand = Random.new()
for (i in 0..4) System.print(chess960.call(W, rand.int(960)))
