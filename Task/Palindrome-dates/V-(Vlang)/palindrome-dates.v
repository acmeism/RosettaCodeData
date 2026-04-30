import time

fn is_palindrome(sg string) bool {
    return sg == sg.reverse()
}

fn main() {
	limit := 15
    mut dt, mut num := 0, 0
    println("First 15 palindromic dates:\n")
    for num < limit {
        dt++
        date := time.now().add_days(dt)
        new_date := "${date.year:04}${date.month:02}${date.day:02}"
        new_date_2 := "${date.year:04}-${date.month:02}-${date.day:02}"
        if is_palindrome(new_date) {
            num++
            println(new_date_2)
        }
    }
}
