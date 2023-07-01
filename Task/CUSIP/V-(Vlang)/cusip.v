fn is_cusip(s string) bool {
    if s.len != 9 { return false }
    mut sum := 0
    for i in 0..8 {
        c := s[i]
        mut v :=0
        match true {
            c >= '0'[0] && c <= '9'[0] {
                v = c - 48
			}
            c >= 'A'[0] && c <= 'Z'[0] {
                v = c - 55
			}
            c == '*'[0] {
                v = 36
			}
            c == '@'[0] {
                v = 37
			}
            c == '#'[0] {
                v = 38
			}
            else {
                return false
			}
        }
        if i % 2 == 1 { v *= 2 }  // check if odd as using 0-based indexing
        sum += v/10 + v%10
    }
    return int(s[8]) - 48 == (10 - (sum%10)) % 10
}

fn main() {
    candidates := [
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105",
	]

    for candidate in candidates {
        mut b :=' '
        if is_cusip(candidate) {
            b = "correct"
        } else {
            b = "incorrect"
        }
        println("$candidate -> $b")
    }
}
