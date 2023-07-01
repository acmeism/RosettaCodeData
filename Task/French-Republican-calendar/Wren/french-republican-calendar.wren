import "/date" for Date
import "/seq" for Lst
import "/fmt" for Fmt

class FrenchRCDate {
    /* uses the 'continuous method' for years after 1805 */
    static isLeapYear(y) {
        var yy = y + 1
         return (yy % 4 == 0) && (yy % 100 != 0 || yy % 400 == 0)
    }

    static parse(frcDate) {
        var splits = frcDate.trim().split(" ")
        if (splits.count == 3) {
            var month = Lst.indexOf(months, splits[1]) + 1
            if (month < 1 || month > 13) Fiber.abort("Invalid month.")
            var year = Num.fromString(splits[2])
            if (year < 1) Fiber.abort("Invalid year.")
            var monthLength = (month < 13) ? 30 : (isLeapYear(year) ? 6 : 5)
            var day = Num.fromString(splits[0])
            if (day < 1 || day > monthLength) Fiber.abort("Invalid day.")
            return FrenchRCDate.new(year, month, day)
        } else if (splits.count == 4 || splits.count == 5) {
            var yearStr = splits[-1]
            var year = Num.fromString(yearStr)
            if (year < 1) Fiber.abort("Invalid year.")
            var scDay = frcDate.trim()[0...-(yearStr.count + 1)]
            var day = Lst.indexOf(intercal, scDay) + 1
            var maxDay = isLeapYear(year) ? 6 : 5
            if (day < 1 || day > maxDay) Fiber.abort("Invalid day.")
            return FrenchRCDate.new(year, 13, day)
         } else Fiber.abort("Invalid French Republican date.")
    }

    /* for convenience we treat 'Sansculottide' as an extra month with 5 or 6 days */
    static months {
        return ["Vendémiaire", "Brumaire", "Frimaire", "Nivôse", "Pluviôse", "Ventôse", "Germinal",
                "Floréal", "Prairial", "Messidor", "Thermidor", "Fructidor", "Sansculottide"]
    }

    static intercal {
        return ["Fête de la vertu", "Fête du génie", "Fête du travail",
                "Fête de l'opinion", "Fête des récompenses", "Fête de la Révolution"]
    }

    static introductionDate { Date.new(1792, 9, 22) }

    /* year = 1..  month = 1..13  day = 1..30 */
    construct new(year, month, day) {
        if (year <= 0 || month < 1 || month > 13) Fiber.abort("Invalid date.")
        if (month < 13) {
            if (day < 1 || day > 30)  Fiber.abort("Invalid date.")
        } else {
            var leap = FrenchRCDate.isLeapYear(year)
            if (leap  && (day < 1 || day > 6)) Fiber.abort("Invalid date.")
            if (!leap && (day < 1 || day > 5)) Fiber.abort("Invalid date.")
        }
        _year = year
        _month = month
        _day = day
    }

    static fromLocalDate(ldate) {
        var daysDiff = (ldate - introductionDate).days + 1
        if (daysDiff <= 0) Fiber.abort("Date can't be before 22 September 1792.")
        var year = 1
        var startDay = 1
        while (true) {
            var endDay = startDay + (isLeapYear(year) ? 365 : 364)
            if (daysDiff >= startDay && daysDiff <= endDay) break
            year = year + 1
            startDay = endDay + 1
        }
        var remDays = daysDiff - startDay
        var month  = (remDays / 30).floor
        var day = remDays - month * 30
        return FrenchRCDate.new(year, month + 1, day + 1)
    }

    toString {
        if (_month < 13) return "%(_day) %(FrenchRCDate.months[_month - 1]) %(_year)"
        return "%(FrenchRCDate.intercal[_day - 1]) %(_year)"
    }

    toLocalDate {
        var sumDays = 0
        for (i in 1..._year) sumDays = sumDays + (FrenchRCDate.isLeapYear(i) ? 366 : 365)
        var dayInYear = (_month - 1) * 30 + _day - 1
        return FrenchRCDate.introductionDate.addDays(sumDays + dayInYear)
    }
}

var fmt = "d| |mmmm| |yyyy"
var dates = [
     "22 September 1792", "20 May 1795", "15 July 1799", "23 September 1803",
     "31 December 1805", "18 March 1871", "25 August 1944", "19 September 2016",
     "22 September 2017", "28 September 2017"
]
var frcDates = List.filled(dates.count, null)
var i = 0
for (date in dates) {
    var thisDate = Date.parse(date, fmt)
    var frcd = FrenchRCDate.fromLocalDate(thisDate)
    frcDates[i] = frcd.toString
    Fmt.print("$-25s => $s", date, frcd)
    i = i + 1
}

// now process the other way around
System.print()
for (frcDate in frcDates) {
    var thisDate = FrenchRCDate.parse(frcDate)
    var lds = thisDate.toLocalDate.format(fmt)
    Fmt.print("$-25s => $s", frcDate, lds)
}
