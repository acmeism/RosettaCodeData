import math
const (
    shaved = [1, 5, 30, 60, 300, 1800, 3600, 21600, 86400] // time shaved off in seconds
    columns = ["1 SECOND", "5 SECONDS", "30 SECONDS", "1 MINUTE", "5 MINUTES",
                   "30 MINUTES", "1 HOUR", "6 HOURS", "1 DAY"]
    diy = 365.25
    minute = 60
    hour = minute * 60
    day = hour * 24
    week = day * 7
    month = day * diy / 12
    year = day * diy
    freq = [50 * diy, 5 * diy, diy, diy/7, 12, 1] // frequency per year
    mult = 5 // multiplier for table
)

fn fmt_time(t f64, interval string) {
    f := int(math.floor(t))
    mut s := interval
    if f>1 {
        s = '${interval}S'
    }
    print(' ${f:-2} ${s:-9}')
}

fn main(){
    title := 'HOW OFTEN YOU DO THE TASK'
    println("${title:58}")
    println('SHAVED OFF   | 50/DAY       5/DAY        DAILY        WEEKLY       MONTHLY      YEARLY')
    println([]string{init:'-',len:93}.join(''))
    for y in 0..columns.len {
    print('${columns[y]:-12} |')
    for x in 0..6 {
       t := freq[x] * shaved[y] * mult
       if t < minute {
            fmt_time(t, "SECOND")
       } else if t < hour {
            fmt_time(t/minute, "MINUTE")
       } else if t < day {
            fmt_time(t/hour, "HOUR")
       } else if t < 14 * day {
            fmt_time(t/day, "DAY")
       } else if t < 9 * week {
            fmt_time(t/week, "WEEK")
       } else if t < year {
            fmt_time(t/month, "MONTH")
       } else {
            print('             ')
       }
    }
    println('')
    }
}
