var Months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
]

class Birthday {
    construct new(month, day) {
        _month = month
        _day = day
    }

    month { _month }
    day   { _day }

    toString { "%(Months[_month-1]) %(day)" }

    monthUniqueIn(bds) { bds.count { |bd| _month == bd.month } == 1 }

    dayUniqueIn(bds)   { bds.count { |bd| _day == bd.day } == 1 }

    monthWithUniqueDayIn(bds) { bds.any { |bd| (_month == bd.month) && bd.dayUniqueIn(bds) } }
}

var choices = [
    Birthday.new(5, 15), Birthday.new(5, 16), Birthday.new(5, 19), Birthday.new(6, 17),
    Birthday.new(6, 18), Birthday.new(7, 14), Birthday.new(7, 16), Birthday.new(8, 14),
    Birthday.new(8, 15), Birthday.new(8, 17)
]

// Albert knows the month but doesn't know the day.
// So the month can't be unique within the choices.
var filtered = choices.where { |bd| !bd.monthUniqueIn(choices) }.toList

// Albert also knows that Bernard doesn't know the answer.
// So the month can't have a unique day.
filtered = filtered.where { |bd| !bd.monthWithUniqueDayIn(filtered) }.toList

// Bernard now knows the answer.
// So the day must be unique within the remaining choices.
filtered = filtered.where { |bd| bd.dayUniqueIn(filtered) }.toList

// Albert now knows the answer too.
// So the month must be unique within the remaining choices.
filtered = filtered.where { |bd| bd.monthUniqueIn(filtered) }.toList

if (filtered.count == 1) {
    System.print("Cheryl's birthday is %(filtered[0])")
} else {
    System.print("Something went wrong!")
}
