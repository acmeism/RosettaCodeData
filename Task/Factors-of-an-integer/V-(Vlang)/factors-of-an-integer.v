fn main() {
	mut arr := []int{len: 100}
	mut n, mut j := 45, 0
	for i in 1..n + 1 {
		if n % i == 0 {
			j++
			arr[j] = i
		}
	}
	print("Factors of ${n} = ")
	for i in 1..j + 1 {print(" ${arr[i]} ")}
}
