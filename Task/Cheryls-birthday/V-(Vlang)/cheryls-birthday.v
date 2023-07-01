import time

struct Birthday {
	month int
	day int
}

fn (b Birthday) str() string {
    return "${time.long_months[b.month-1]} $b.day"
}

fn (b Birthday) month_uniquie_in(bds []Birthday) bool {
    mut count := 0
    for bd in bds {
        if bd.month == b.month {
            count++
        }
    }
    if count == 1 {
        return true
    }
    return false
}

fn (b Birthday) day_unique_in(bds []Birthday) bool {
    mut count := 0
    for bd in bds {
        if bd.day == b.day {
            count++
        }
    }
    if count == 1 {
        return true
    }
    return false
}

fn (b Birthday) month_with_unique_day_in(bds []Birthday) bool {
    for bd in bds {
        if bd.month == b.month && bd.day_unique_in(bds) {
            return true
        }
    }
    return false
}

fn main() {
    choices := [
        Birthday{5, 15}, Birthday{5, 16}, Birthday{5, 19}, Birthday{6, 17}, Birthday{6, 18},
        Birthday{7, 14}, Birthday{7, 16}, Birthday{8, 14}, Birthday{8, 15}, Birthday{8, 17},
	]

    // Albert knows the month but doesn't know the day.
    // So the month can't be unique within the choices.
    mut filtered := []Birthday{}
    for bd in choices {
        if !bd.month_uniquie_in(choices) {
            filtered << bd
        }
    }

    // Albert also knows that Bernard doesn't know the answer.
    // So the month can't have a unique day.
    mut filtered2 := []Birthday{}
    for bd in filtered {
        if !bd.month_with_unique_day_in(filtered) {
            filtered2 << bd
        }
    }

    // Bernard now knows the answer.
    // So the day must be unique within the remaining choices.
    mut filtered3 := []Birthday{}
    for bd in filtered2 {
        if bd.day_unique_in(filtered2) {
            filtered3 << bd
        }
    }

    // Albert now knows the answer too.
    // So the month must be unique within the remaining choices.
    mut filtered4 := []Birthday{}
    for bd in filtered3 {
        if bd.month_uniquie_in(filtered3) {
            filtered4 << bd
        }
    }

    if filtered4.len == 1 {
        println("Cheryl's Birthday is ${filtered4[0]}")
    } else {
        println("Something went wrong!")
    }
}
