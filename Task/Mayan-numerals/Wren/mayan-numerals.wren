import "./fmt" for Conv

var ul = "╔"
var uc = "╦"
var ur = "╗"
var ll = "╚"
var lc = "╩"
var lr = "╝"
var hb = "═"
var vb = "║"

var mayan= [
    "    ",
    " ∙  ",
    " ∙∙ ",
    "∙∙∙ ",
    "∙∙∙∙"
]

var m0 = " Θ  "
var m5 = "────"

var dec2vig = Fn.new { |n| Conv.itoa(n, 20).map { |c| Conv.atoi(c, 20) }.toList }

var vig2quin = Fn.new { |n|
    if (n >= 20) Fiber.abort("Cant't convert a number >= 20.")
    var res = [mayan[0], mayan[0], mayan[0], mayan[0]]
    if (n == 0) {
        res[3] = m0
        return res
    }
    var fives = (n/5).floor
    var rem = n % 5
    res[3-fives] = mayan[rem]
    for (i in 3...3-fives) res[i] = m5
    return res
}

var draw = Fn.new { |mayans|
    var lm = mayans.count
    System.write(ul)
    for (i in 0...lm) {
        for (j in 0..3) System.write(hb)
        if (i < lm - 1) {
            System.write(uc)
        } else {
            System.print(ur)
        }
    }
    for (i in 1..4) {
        System.write(vb)
        for (j in 0...lm) {
            System.write(mayans[j][i-1])
            System.write(vb)
        }
        System.print()
    }
    System.write(ll)
    for (i in 0...lm) {
        for (j in 0..3) System.write(hb)
        if (i < lm - 1) {
            System.write(lc)
        } else {
            System.print(lr)
        }
    }
}

var numbers = [4005, 8017, 326205, 886205, 1081439556]
for (n in numbers) {
    System.print("Converting %(n) to Mayan:")
    var vigs = dec2vig.call(n)
    var mayans = vigs.map { |vig| vig2quin.call(vig) }.toList
    draw.call(mayans)
    System.print()
}
