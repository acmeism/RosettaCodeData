fn egyptian_divide(dividend int, divisor int) ?(int, int) {

    if dividend < 0 || divisor <= 0 {
        panic("Invalid argument(s)")
    }
    if dividend < divisor {
        return 0, dividend
    }
    mut powers_of_two := [1]
    mut doublings := [divisor]
    mut doubling := divisor
    for {
        doubling *= 2
        if doubling > dividend {
            break
        }
        l := powers_of_two.len
        powers_of_two << powers_of_two[l-1]*2
        doublings << doubling
    }
    mut answer := 0
    mut accumulator := 0
    for i := doublings.len - 1; i >= 0; i-- {
        if accumulator+doublings[i] <= dividend {
            accumulator += doublings[i]
            answer += powers_of_two[i]
            if accumulator == dividend {
                break
            }
        }
    }
    return answer, dividend - accumulator
}

fn main() {
    dividend := 580
    divisor := 34
    quotient, remainder := egyptian_divide(dividend, divisor)?
    println("$dividend divided by $divisor is $quotient with remainder $remainder")
}
