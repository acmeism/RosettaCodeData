const (
    input = '49927398716
49927398717
1234567812345678
1234567812345670'

    t = [0, 2, 4, 6, 8, 1, 3, 5, 7, 9]
)

fn luhn(s string) bool {
    odd := s.len & 1
    mut sum := 0
    for i, c in s.split('') {
        if c < '0' || c > '9' {
            return false
        }
        if i&1 == odd {
            sum += t[c.int()-'0'.int()]
        } else {
            sum += c.int() - '0'.int()
        }
    }
    return sum%10 == 0
}

fn main() {
    for s in input.split("\n") {
        println('$s ${luhn(s)}')
    }
}
