import "/fmt" for Fmt

var n

var init = Fn.new {
    n = List.filled(15, null)
    for (i in 0..14) {
        n[i] = List.filled(11, " ")
        n[i][5] = "x"
    }
}

var horiz = Fn.new { |c1, c2, r| (c1..c2).each { |c| n[r][c] = "x" } }
var verti = Fn.new { |r1, r2, c| (r1..r2).each { |r| n[r][c] = "x" } }
var diagd = Fn.new { |c1, c2, r| (c1..c2).each { |c| n[r+c-c1][c] = "x" } }
var diagu = Fn.new { |c1, c2, r| (c1..c2).each { |c| n[r-c+c1][c] = "x" } }

var draw // map contains recursive closures
draw = {
    1: Fn.new { horiz.call(6, 10, 0) },
    2: Fn.new { horiz.call(6, 10, 4) },
    3: Fn.new { diagd.call(6, 10, 0) },
    4: Fn.new { diagu.call(6, 10, 4) },
    5: Fn.new {
           draw[1].call()
           draw[4].call()
       },
    6: Fn.new { verti.call(0, 4, 10) },
    7: Fn.new {
           draw[1].call()
           draw[6].call()
       },
    8: Fn.new {
           draw[2].call()
           draw[6].call()
       },
    9: Fn.new {
           draw[1].call()
           draw[8].call()
       },
    10: Fn.new { horiz.call(0, 4, 0) },
    20: Fn.new { horiz.call(0, 4, 4) },
    30: Fn.new { diagu.call(0, 4, 4) },
    40: Fn.new { diagd.call(0, 4, 0) },
    50: Fn.new {
           draw[10].call()
           draw[40].call()
        },
    60: Fn.new { verti.call(0, 4, 0) },
    70: Fn.new {
           draw[10].call()
           draw[60].call()
        },
    80: Fn.new {
           draw[20].call()
           draw[60].call()
        },
    90: Fn.new {
           draw[10].call()
           draw[80].call()
        },
    100: Fn.new { horiz.call(6, 10, 14) },
    200: Fn.new { horiz.call(6, 10, 10) },
    300: Fn.new { diagu.call(6, 10, 14) },
    400: Fn.new { diagd.call(6, 10, 10) },
    500: Fn.new {
            draw[100].call()
            draw[400].call()
         },
    600: Fn.new { verti.call(10, 14, 10) },
    700: Fn.new {
            draw[100].call()
            draw[600].call()
         },
    800: Fn.new {
            draw[200].call()
            draw[600].call()
         },
    900: Fn.new {
            draw[100].call()
            draw[800].call()
         },
    1000: Fn.new { horiz.call(0, 4, 14) },
    2000: Fn.new { horiz.call(0, 4, 10) },
    3000: Fn.new { diagd.call(0, 4, 10) },
    4000: Fn.new { diagu.call(0, 4, 14) },
    5000: Fn.new {
             draw[1000].call()
             draw[4000].call()
          },
    6000: Fn.new { verti.call(10, 14, 0) },
    7000: Fn.new {
             draw[1000].call()
             draw[6000].call()
          },
    8000: Fn.new {
             draw[2000].call()
             draw[6000].call()
          },
    9000: Fn.new {
             draw[1000].call()
             draw[8000].call()
          }
}

var numbers = [0, 1, 20, 300, 4000, 5555, 6789, 9999]
for (number in numbers) {
    init.call()
    System.print("%(number):")
    var thousands = (number/1000).floor
    number = number % 1000
    var hundreds  = (number/100).floor
    number = number % 100
    var tens = (number/10).floor
    var ones = number % 10
    if (thousands > 0) draw[thousands*1000].call()
    if (hundreds > 0) draw[hundreds*100].call()
    if (tens > 0) draw[tens*10].call()
    if (ones > 0) draw[ones].call()
    Fmt.mprint(n, 1, 0, "")
    System.print()
}
