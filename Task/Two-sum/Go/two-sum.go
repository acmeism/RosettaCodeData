package main

import "fmt"

func twoSum(a []int, targetSum int) (int, int, bool) {
    len := len(a)
    if len < 2 {
        return 0, 0, false
    }
    for i := 0; i < len - 1; i++ {
        if a[i] <= targetSum {
            for j := i + 1; j < len; j++ {
                sum := a[i] + a[j]
                if sum == targetSum {
                    return i, j, true
                }
                if sum > targetSum {
                    break
                }
            }
        } else {
            break
        }
    }
    return 0, 0, false
}

func main() {
    a := []int {0, 2, 11, 19, 90}
    targetSum := 21
    p1, p2, ok := twoSum(a, targetSum)
    if (!ok) {
        fmt.Println("No two numbers were found whose sum is", targetSum)
    } else {
        fmt.Println("The numbers with indices", p1, "and", p2, "sum to", targetSum)
    }
}
