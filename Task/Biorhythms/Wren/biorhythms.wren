import "./date" for Date
import "./fmt" for Fmt

var cycles = ["Physical day ", "Emotional day", "Mental day   "]
var lengths = [23, 28, 33]
var quadrants = [
    ["up and rising",    "peak"],
    ["up but falling",   "transition"],
    ["down and falling", "valley"],
    ["down but rising",  "transition"]
]

var biorhythms = Fn.new { |birthDate, targetDate|
    var bd = Date.parse(birthDate)
    var td = Date.parse(targetDate)
    var days = (td - bd).days
    Date.default = Date.isoDate
    System.print("Born %(birthDate), Target %(targetDate)")
    System.print("Day %(days)")
    for (i in 0..2) {
        var length   = lengths[i]
        var cycle    = cycles[i]
        var position = days % length
        var quadrant = (position / length * 4).floor
        var percent  = ((2 * Num.pi * position / length).sin * 1000).floor / 10
        var descript = (percent > 95)    ? " peak" :
                       (percent < -95)   ? " valley" :
                       (percent.abs < 5) ? " critical transition" : "other"
        if (descript == "other") {
            var transition  = td.addDays(((quadrant + 1) / 4 * length).floor - position)
            var tn = quadrants[quadrant]
            var trend = tn[0]
            var next = tn[1]
            descript = Fmt.swrite("$5.1f\% ($s, next $s $s)", percent, trend, next, transition)
        }
        Fmt.print("$s $2d : $s", cycle, position, descript)
    }
    System.print()
}

var datePairs = [
    ["1943-03-09", "1972-07-11"],
    ["1809-01-12", "1863-11-19"],
    ["1809-02-12", "1863-11-19"]  // correct DOB for Abraham Lincoln
]
for (datePair in datePairs) biorhythms.call(datePair[0], datePair[1])
