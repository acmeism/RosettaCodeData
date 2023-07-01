import "/date" for Date
import "/fmt" for Fmt
import "/iterate" for Stepped

var holidayOffsets = [
    ["Easter", 0],
    ["Ascension", 39],
    ["Pentecost", 49],
    ["Trinity", 56],
    ["C/Christi", 60]
]

var calculateEaster = Fn.new { |year|
    var a = year % 19
    var b = (year / 100).floor
    var c = year % 100
    var d = (b / 4).floor
    var e = b % 4
    var f = ((b + 8) / 25).floor
    var g = ((b - f + 1) / 3).floor
    var h = (19 * a + b - d - g + 15) % 30
    var i = (c / 4).floor
    var k = c % 4
    var l = (32 + 2 * e + 2 * i - h - k) % 7
    var m = ((a + 11 * h + 22 * l) / 451).floor
    var n = h + l - 7 * m + 114
    var month = (n / 31).floor // months indexed from 1
    var day = (n % 31) + 1
    return Date.new(year, month, day)
}

var outputHolidays = Fn.new { |year|
    var date = calculateEaster.call(year)
    Fmt.write("$4d  ", year)
    var po = 0
    for (ho in holidayOffsets) {
        var h = ho[0]
        var o = ho[1]
        date = date.addDays(o - po)
        po = o
        var ds = date.format("dd| |mmm|")
        Fmt.write("$*m  ", h.count, ds)
    }
    System.print()
}

System.print("Year  Easter  Ascension  Pentecost  Trinity  C/Christi")
System.print(" CE   Sunday  Thursday    Sunday    Sunday   Thursday ")
System.print("----  ------  ---------  ---------  -------  ---------")
for (year in Stepped.new(400..2100, 100)) outputHolidays.call(year)
System.print()
for (year in 2010..2020) outputHolidays.call(year)
