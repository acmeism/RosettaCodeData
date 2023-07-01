import "/str" for Str

var board  = "ET AON RISBCDFGHJKLMPQ/UVWXYZ."
var digits = "0123456789"
var rows   = " 26"
var escape = "62"
var key    = "0452"

var encrypt = Fn.new { |message|
    var msg = Str.upper(message).
              where { |c| (board.contains(c) || digits.contains(c)) && !" /".contains(c) }.join()
    var sb = ""
    for (c in msg) {
        var idx = board.indexOf(c)
        if (idx > -1) {
            var row = (idx/10).floor
            var col = idx % 10
            sb = sb + ((row == 0) ? "%(col)" : "%(rows[row])%(col)")
        } else {
            sb = sb + "%(escape)%(c)"
        }
    }
    var enc = sb.bytes.toList
    var i = 0
    for (c in enc) {
        var k = key[i%4].bytes[0] - 48
        if (k != 0) {
            var j = c - 48
            enc[i] = 48 + ((j + k) % 10)
        }
        i = i + 1
    }
    return enc.map { |b| String.fromByte(b) }.join()
}

var decrypt = Fn.new { |encoded|
    var enc = encoded.bytes.toList
    var i = 0
    for (c in enc) {
        var k = key[i%4].bytes[0] - 48
        if (k != 0) {
            var j = c - 48
            enc[i] = 48 + ((j >= k) ? (j - k) % 10 : (10 + j - k) % 10)
        }
        i = i + 1
    }
    var len = enc.count
    var sb = ""
    i = 0
    while (i < len) {
        var c = enc[i]
        var idx = rows.indexOf((c-48).toString)
        if (idx == -1) {
            var idx2 = c - 48
            sb = sb + board[idx2]
            i = i + 1
        } else if ("%(c-48)%(enc[i + 1]-48)" == escape) {
            sb = sb + (enc[i + 2] - 48).toString
            i = i + 3
        } else {
            var idx2 = idx * 10 + enc[i + 1] - 48
            sb = sb + board[idx2]
            i = i + 2
        }
    }
    return sb
}

var messages = [
    "Attack at dawn",
    "One night-it was on the twentieth of March, 1888-I was returning",
    "In the winter 1965/we were hungry/just barely alive",
    "you have put on 7.5 pounds since I saw you.",
    "The checkerboard cake recipe specifies 3 large eggs and 2.25 cups of flour."
]
for (message in messages) {
    var encrypted = encrypt.call(message)
    var decrypted = decrypt.call(encrypted)
    System.print("\nMessage   : %(message)")
    System.print("Encrypted : %(encrypted)")
    System.print("Decrypted : %(decrypted)")
}
