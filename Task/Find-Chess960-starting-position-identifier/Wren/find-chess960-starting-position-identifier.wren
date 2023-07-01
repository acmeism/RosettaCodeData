import "/iterate" for Indexed

var glyphs  = "♜♞♝♛♚♖♘♗♕♔".toList
var letters = "RNBQKRNBQK"
var names = { "R": "rook", "N": "knight", "B": "bishop", "Q": "queen", "K": "king" }
var g2lMap = {}
for (se in Indexed.new(glyphs)) g2lMap[glyphs[se.index]] = letters[se.index]

var g2l = Fn.new { |pieces| pieces.reduce("") { |acc, p| acc + g2lMap[p] } }

var ntable = { "01":0, "02":1, "03":2, "04":3, "12":4, "13":5, "14":6, "23":7, "24":8, "34":9 }

var spid = Fn.new { |pieces|
    pieces = g2l.call(pieces) // convert glyphs to letters

    /* check for errors */
    if (pieces.count != 8) Fiber.abort("There must be exactly 8 pieces.")
    for (one in "KQ") {
        if (pieces.count { |p| p == one } != 1 ) Fiber.abort("There must be one %(names[one]).")
    }
    for (two in "RNB") {
        if (pieces.count { |p| p == two } != 2 ) Fiber.abort("There must be two %(names[two])s.")
    }
    var r1 = pieces.indexOf("R")
    var r2 = pieces.indexOf("R", r1 + 1)
    var k  = pieces.indexOf("K")
    if (k < r1 || k > r2) Fiber.abort("The king must be between the rooks.")
    var b1 = pieces.indexOf("B")
    var b2 = pieces.indexOf("B", b1 + 1)
    if ((b2 - b1) % 2 == 0) Fiber.abort("The bishops must be on opposite color squares.")

    /* compute SP_ID */
    var piecesN = pieces.replace("Q", "").replace("B", "")
    var n1 = piecesN.indexOf("N")
    var n2 = piecesN.indexOf("N", n1 + 1)
    var np = "%(n1)%(n2)"
    var N = ntable[np]

    var piecesQ = pieces.replace("B", "")
    var Q = piecesQ.indexOf("Q")

    var D = "0246".indexOf(b1.toString)
    var L = "1357".indexOf(b2.toString)
    if (D == -1) {
        D = "0246".indexOf(b2.toString)
        L = "1357".indexOf(b1.toString)
    }

    return 96*N + 16*Q + 4*D + L
}

for (pieces in ["♕♘♖♗♗♘♔♖", "♖♘♗♕♔♗♘♖", "♜♛♞♝♝♚♜♞", "♜♞♛♝♝♚♜♞"]) {
    System.print("%(pieces) or %(g2l.call(pieces)) has SP-ID of %(spid.call(pieces))")
}
