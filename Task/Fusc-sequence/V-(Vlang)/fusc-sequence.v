fn main() {
	mut max_len, mut temp := 0, 0
	println("First 61 terms:")
	for i := 0; i < 60; i++ {
		print("${fusc(i)} ")
	}
	println(fusc(60))
	println("\nNumbers whose length is greater than any previous fusc number length:")
	println("Index:\tValue:")
	// less than 700,000 used
	for i := 0; i < 700000; i++ {
		temp = fusc(i)
		if temp.str().len > max_len {
		max_len = temp.str().len
		println("${i}\t${temp}")
		}
	}
}

fn fusc(n int) int {
  if n <= 1 {return n}
  else if n % 2 == 0 {return fusc(n / 2)}
  else {return fusc((n - 1) / 2) + fusc((n + 1) / 2)}
}
