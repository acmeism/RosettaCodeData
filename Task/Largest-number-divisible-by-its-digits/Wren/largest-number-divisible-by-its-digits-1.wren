var divByAll = Fn.new { |n, digits| digits.all { |d| n%(d-48) == 0 } }

var magic = 9 * 8 * 7
var high = (9876432/magic).floor * magic
var i = high
while (i >= magic) {
    if (i%10 != 0) {  // can't end in '0'
        var s = "%(i)"
        if (!s.contains("0") && !s.contains("5")) { // can't contain '0' or '5'
            var set = {}
            var sd = [] // list of distinct digits
            for (b in s.bytes) {
                if (set[b] == null) {
                    set[b] = true
                    sd.add(b)
                }
            }
            if (sd.count == s.count) { // digits must be unique
                if (divByAll.call(i, sd)) {
                    System.print("Largest decimal number is %(i)")
                    return
                }
            }
        }
    }
    i = i - magic
}
