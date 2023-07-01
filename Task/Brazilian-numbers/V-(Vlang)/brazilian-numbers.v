fn same_digits(nn int, b int) bool {
    f := nn % b
    mut n := nn/b
    for n > 0 {
        if n%b != f {
            return false
        }
        n /= b
    }
    return true
}

fn is_brazilian(n int) bool {
    if n < 7 {
        return false
    }
    if n%2 == 0 && n >= 8 {
        return true
    }
    for b in 2..n-1 {
        if same_digits(n, b) {
            return true
        }
    }
    return false
}

fn is_prime(n int) bool {
    match true {
		n < 2 {
			return false
		}
		n%2 == 0 {
			return n == 2
		}
		n%3 == 0 {
			return n == 3
		}
		else {
			mut d := 5
			for d*d <= n {
				if n%d == 0 {
					return false
				}
				d += 2
				if n%d == 0 {
					return false
				}
				d += 4
			}
			return true
		}
    }
}

fn main() {
    kinds := [" ", " odd ", " prime "]
    for kind in kinds {
        println("First 20${kind}Brazilian numbers:")
        mut c := 0
        mut n := 7
        for {
            if is_brazilian(n) {
                print("$n ")
                c++
                if c == 20 {
                    println("\n")
                    break
                }
            }
            match kind {
				" " {
					n++
				}
				" odd " {
					n += 2
				}
				" prime "{
					for {
						n += 2
						if is_prime(n) {
							break
						}
					}
				}
				else{}
            }
        }
    }

    mut n := 7
    for c := 0; c < 100000; n++ {
        if is_brazilian(n) {
            c++
        }
    }
    println("The 100,000th Brazilian number: ${n-1}")
}
