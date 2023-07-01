fn main() {
    mut count, mut i := 0, 0
	print("The first 20 Harshad numbers: ")
    for {
		i++
        if is_harshad(i) == true {
            if count < 20 {print("${i} ") count++}
			if i > 1000 {print("\nThe first Harshad number above 1000: ${i}") break}
        }
    }
}

fn sum_digits(number int) int {
    mut num, mut sum := number, 0
	if number <= 0 {return 0}
	for num > 0 {
		sum += num % 10
		num /= 10
	}
	return sum
}

fn is_harshad(n int) bool {
	if n % sum_digits(n) == 0 {return true}
	return false
}
