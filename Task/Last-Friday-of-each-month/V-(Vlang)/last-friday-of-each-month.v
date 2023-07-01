import time
import os

fn main() {
    mut year := 0
    mut t := time.now()
    year = os.input("Please select a year: ").int()
    println("Last Fridays of each month of $year")
    println("==================================")
    for i in 1..13 {
        mut j := time.month_days[i-1]
        if i == 2 {
            if time.is_leap_year(year) {j = 29}
        }
        for {
            t = time.parse('$year-${i:02}-$j 12:30:00')!
            if t.weekday_str() == 'Fri' {
                println("${time.long_months[i-1]}: $j")
                break
            }
            j--
        }
    }
}
