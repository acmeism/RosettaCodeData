fn is_leap(year int) bool {
    return year %400 ==0 || (year%4 ==0 && year%100!=0)
}

fn main() {
    for y in 1950..2012 {
        if is_leap(y) {
            println(y)
        }
    }
}
