fn is_humble(i int) bool {
    if i <= 1 {return true}
    if i % 2 == 0 {return is_humble(i / 2)}
    if i % 3 == 0 {return is_humble(i / 3)}
    if i % 5 == 0 {return is_humble(i / 5)}
    if i % 7 == 0 {return is_humble(i / 7)}
    return false
}

fn main() {
    limit := max_i16
    mut humble := map[int]int{}
    mut count, mut len, mut total, mut num  := 0, 0, 0, 1
	mut str :=""

    for count < limit {
        if is_humble(num) == true {
            str = num.str()
            len = str.len
			humble[len]++
            if count < 50 {print("${num} ")}
            count++
        }
        num++
    }
    println("\n")

    println("Of the first ${count} humble numbers:")
    num = 1
    for num < humble.len - 1 {
        if num in humble {
            total = humble[num]
            println("${total:5} have ${num:2} digits")
            num++
        }
		else {break}
    }
}
