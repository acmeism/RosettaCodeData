import math

fn main() {
	mut num, mut nr := 0, 0
	mut tax := []int{}
	for n in 0 .. 500000 {
		nr = 0
		tax.clear()
		for m in 0 .. 74 {
			for p in m + 0 .. 74 {
				if n == math.pow(m, 3) + math.pow(p, 3) {
					tax << m
					tax << p
					nr++
				}
			}
		}
		if nr > 1 {
			num++
			print(" ${num:2} ${n:6} => ${tax[0]:2}³ + ${tax[1]:2}³, ")
			print(" ${tax[2]:2}³ + ${tax[3]:2}³" + "\n")
			if num == 25 {exit}
		}
	}
	print("ok" + "\n")
}
