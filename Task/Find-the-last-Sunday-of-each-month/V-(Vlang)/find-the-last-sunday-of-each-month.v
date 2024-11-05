import time
import os

fn main() {
    mut year := ""
    mut now, mut mdx := time.now(), time.month_days[0]
	for year.len != 4 || !year.split("").any(it.is_int()) {
    	year = os.input("What year to calculate (yyyy): ")
	}
    println("Last Sunday for each month of ${year}")
    println("==================================")
    for idx in 1..13 {
        mdx = time.month_days[idx - 1]
        if idx == 2 && time.is_leap_year(year.int()) {mdx = 29}
        for {
            now = time.parse("$year-${idx:02}-${mdx} 12:30:00")!
            if now.weekday_str() == "Sun" {
                println("${time.long_months[idx -1 ]}: ${mdx}")
                break
            }
            mdx--
        }
    }
}
