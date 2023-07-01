package main

import "fmt"

func egyptianDivide(dividend, divisor int) (quotient, remainder int) {
    if dividend < 0 || divisor <= 0 {
        panic("Invalid argument(s)")
    }
    if dividend < divisor {
        return 0, dividend
    }
    powersOfTwo := []int{1}
    doublings := []int{divisor}
    doubling := divisor
    for {
        doubling *= 2
        if doubling > dividend {
            break
        }
        l := len(powersOfTwo)
        powersOfTwo = append(powersOfTwo, powersOfTwo[l-1]*2)
        doublings = append(doublings, doubling)
    }
    answer := 0
    accumulator := 0
    for i := len(doublings) - 1; i >= 0; i-- {
        if accumulator+doublings[i] <= dividend {
            accumulator += doublings[i]
            answer += powersOfTwo[i]
            if accumulator == dividend {
                break
            }
        }
    }
    return answer, dividend - accumulator
}

func main() {
    dividend := 580
    divisor := 34
    quotient, remainder := egyptianDivide(dividend, divisor)
    fmt.Println(dividend, "divided by", divisor, "is", quotient, "with remainder", remainder)
}
