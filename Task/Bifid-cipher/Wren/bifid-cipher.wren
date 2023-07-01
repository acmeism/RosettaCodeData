import "./str" for Str
import "./seq" for Lst

class Bifid {
    static encrypt(polybius, message) {
        message = Str.upper(message).replace("J", "I")
        var rows = []
        var cols = []
        for (c in message) {
            var ix = polybius.indexOf(c)
            if (ix == -1) continue
            rows.add((ix/5).floor + 1)
            cols.add((ix%5) + 1)
        }
        var s = ""
        for (pair in Lst.chunks(rows + cols, 2)) {
            var ix = (pair[0] - 1) * 5 + pair[1] - 1
            s = s + polybius[ix]
        }
        return s
    }

    static decrypt(polybius, message) {
        var rows = []
        var cols = []
        for (c in message) {
            var ix = polybius.indexOf(c)
            rows.add((ix/5).floor + 1)
            cols.add((ix%5) + 1)
        }
        var lines = Lst.flatten(Lst.zip(rows, cols))
        var count = lines.count/2
        rows = lines[0...count]
        cols = lines[count..-1]
        var s = ""
        for (i in 0...count) {
            var ix = (rows[i] - 1) * 5 + cols[i] - 1
            s = s + polybius[ix]
        }
        return s
    }
}
var poly1 = "ABCDEFGHIKLMNOPQRSTUVWXYZ"
var poly2 = "BGWKZQPNDSIOAXEFCLUMTHYVR"
var poly3 = "PLAYFIREXMBCDGHKNOQSTUVWZ"
var polys = [poly1, poly2, poly2, poly3]
var msg1  = "ATTACKATDAWN"
var msg2  = "FLEEATONCE"
var msg3  = "The invasion will start on the first of January"
var msgs  = [msg1, msg2, msg1, msg3]
for (i in 0...msgs.count) {
    var encrypted = Bifid.encrypt(polys[i], msgs[i])
    var decrypted = Bifid.decrypt(polys[i], encrypted)
    System.print("Message   : %(msgs[i])")
    System.print("Encrypted : %(encrypted)")
    System.print("Decrypted : %(decrypted)")
    if (i < msgs.count-1) System.print()
}
