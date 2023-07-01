import time

fn main() {
    for year := 2008; year <= 2121; year++ {
        date := time.parse('${year}-12-25 00:00:00') or { continue }
        if date.long_weekday_str() == 'Sunday' {
            println('December 25 ${year} is a ${date.long_weekday_str()}')
        }
    }
}
