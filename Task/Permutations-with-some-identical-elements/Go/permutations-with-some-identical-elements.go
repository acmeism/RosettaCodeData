package main

import "fmt"

func shouldSwap(s []byte, start, curr int) bool {
    for i := start; i < curr; i++ {
        if s[i] == s[curr] {
            return false
        }
    }
    return true
}

func findPerms(s []byte, index, n int, res *[]string) {
    if index >= n {
        *res = append(*res, string(s))
        return
    }
    for i := index; i < n; i++ {
        check := shouldSwap(s, index, i)
        if check {
            s[index], s[i] = s[i], s[index]
            findPerms(s, index+1, n, res)
            s[index], s[i] = s[i], s[index]
        }
    }
}

func createSlice(nums []int, charSet string) []byte {
    var chars []byte
    for i := 0; i < len(nums); i++ {
        for j := 0; j < nums[i]; j++ {
            chars = append(chars, charSet[i])
        }
    }
    return chars
}

func main() {
    var res, res2, res3 []string
    nums := []int{2, 1}
    s := createSlice(nums, "12")
    findPerms(s, 0, len(s), &res)
    fmt.Println(res)
    fmt.Println()

    nums = []int{2, 3, 1}
    s = createSlice(nums, "123")
    findPerms(s, 0, len(s), &res2)
    fmt.Println(res2)
    fmt.Println()

    s = createSlice(nums, "ABC")
    findPerms(s, 0, len(s), &res3)
    fmt.Println(res3)
}
