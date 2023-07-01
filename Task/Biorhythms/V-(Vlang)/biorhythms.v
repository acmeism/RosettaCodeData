import time
import math

const cycles = ["Physical day ", "Emotional day", "Mental day   "]
const lengths = [23, 28, 33]
const quadrants = [
    ["up and rising", "peak"],
    ["up but falling", "transition"],
    ["down and falling", "valley"],
    ["down but rising", "transition"],
]

// Parameters assumed to be in YYYY-MM-DD format.
fn biorhythms(birth_date string, target_date string) ? {
    bd := time.parse_iso8601(birth_date)?
    td := time.parse_iso8601(target_date)?
    days := int((td-bd).hours() / 24)
    println("Born $birth_date, Target $target_date")
    println("Day $days")
    for i in 0..3 {
        length := lengths[i]
        cycle := cycles[i]
        position := days % length
        quadrant := position * 4 / length
        mut percent := math.sin(2 * math.pi * f64(position) / f64(length))
        percent = math.floor(percent*1000) / 10
        mut descript := ""
        if percent > 95 {
            descript = " peak"
        } else if percent < -95 {
            descript = " valley"
        } else if math.abs(percent) < 5 {
            descript = " critical transition"
        } else {
            days_to_add := (quadrant+1)*length/4 - position
            transition := td.add(time.hour * 24 * time.Duration(days_to_add))
            trend := quadrants[quadrant][0]
            next := quadrants[quadrant][1]
            trans_str := transition.custom_format('YYYY-MM-DD')
            descript = "${percent:5.1f}% ($trend, next $next $trans_str)"
        }
        println("$cycle ${position:2} : $descript")
    }
    println('')
}

fn main() {
    date_pairs := [
        ["1943-03-09", "1972-07-11"],
        ["1809-01-12", "1863-11-19"],
        ["1809-02-12", "1863-11-19"], // correct DOB for Abraham Lincoln
	]
    for date_pair in date_pairs {
        biorhythms(date_pair[0], date_pair[1])?
    }
}
