import time

fn days_between(d1 string, d2 string) !int {
    t1 := time.parse('$d1 01:01:01')!
    t2 := time.parse('$d2 01:01:01')!
    days := int((t2-t1).hours()/24)
    return days
}

fn main(){
    mut date1,mut date2 := "2019-01-01", "2019-09-30"
    mut days := days_between(date1, date2)!
    println("There are $days days between $date1 and $date2")

    date1, date2 = "2015-12-31", "2016-09-30"
    days = days_between(date1, date2)!
    println("There are $days days between $date1 and $date2")
}
