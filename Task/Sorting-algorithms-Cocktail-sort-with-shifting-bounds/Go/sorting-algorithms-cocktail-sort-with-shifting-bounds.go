package main

import (
    "fmt"
    "math/rand"
    "time"
)

// translation of pseudo-code
func cocktailShakerSort(a []int) {
    var begin = 0
    var end = len(a) - 2
    for begin <= end {
        newBegin := end
        newEnd := begin
        for i := begin; i <= end; i++ {
            if a[i] > a[i+1] {
                a[i+1], a[i] = a[i], a[i+1]
                newEnd = i
            }
        }
        end = newEnd - 1
        for i := end; i >= begin; i-- {
            if a[i] > a[i+1] {
                a[i+1], a[i] = a[i], a[i+1]
                newBegin = i
            }
        }
        begin = newBegin + 1
    }
}

// from the RC Cocktail sort task (no optimizations)
func cocktailSort(a []int) {
    last := len(a) - 1
    for {
        swapped := false
        for i := 0; i < last; i++ {
            if a[i] > a[i+1] {
                a[i], a[i+1] = a[i+1], a[i]
                swapped = true
            }
        }
        if !swapped {
            return
        }
        swapped = false
        for i := last - 1; i >= 0; i-- {
            if a[i] > a[i+1] {
                a[i], a[i+1] = a[i+1], a[i]
                swapped = true
            }
        }
        if !swapped {
            return
        }
    }
}

func main() {
    // First make sure the routines are working correctly.
    a := []int{21, 4, -9, 62, -7, 107, -62, 4, 0, -170}
    fmt.Println("Original array:", a)
    b := make([]int, len(a))
    copy(b, a) // as sorts mutate array in place
    cocktailSort(a)
    fmt.Println("Cocktail sort :", a)
    cocktailShakerSort(b)
    fmt.Println("C/Shaker sort :", b)

    // timing comparison code
    rand.Seed(time.Now().UnixNano())
    fmt.Println("\nRelative speed of the two sorts")
    fmt.Println("  N    x faster (CSS v CS)")
    fmt.Println("-----  -------------------")
    const runs = 10 // average over 10 runs say
    for _, n := range []int{1000, 2000, 4000, 8000, 10000, 20000} {
        sum := 0.0
        for i := 1; i <= runs; i++ {
            // get 'n' random numbers in range [0, 100,000]
            // with every other number being negated
            nums := make([]int, n)
            for i := 0; i < n; i++ {
                rn := rand.Intn(100000)
                if i%2 == 1 {
                    rn = -rn
                }
                nums[i] = rn
            }
            // copy the array
            nums2 := make([]int, n)
            copy(nums2, nums)

            start := time.Now()
            cocktailSort(nums)
            elapsed := time.Since(start)
            start2 := time.Now()
            cocktailShakerSort(nums2)
            elapsed2 := time.Since(start2)
            sum += float64(elapsed) / float64(elapsed2)
        }
        fmt.Printf(" %2dk      %0.3f\n", n/1000, sum/runs)
    }
}
