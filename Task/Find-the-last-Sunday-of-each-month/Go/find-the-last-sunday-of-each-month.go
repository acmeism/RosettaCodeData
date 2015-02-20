package main

import (
	"fmt"
	"time"
)

func main() {
	
	var year int
	var t time.Time
	var lastDay = [12]int { 31,29,31,30,31,30,31,31,30,31,30,31 }
	
	for {
		fmt.Print("Please select a year: ")
		_, err := fmt.Scanf("%d", &year)
		if err != nil {
			fmt.Println(err)
			continue
		} else {
			break
		}
	}

	fmt.Println("Last Sundays of each month of", year)
	fmt.Println("==================================")

	for i := 1;i < 13; i++ {
		j := lastDay[i-1]
		if i == 2 {
			if time.Date(int(year), time.Month(i), j, 0, 0, 0, 0, time.UTC).Month() == time.Date(int(year), time.Month(i), j-1, 0, 0, 0, 0, time.UTC).Month() {
				j = 29
			} else {
				j = 28
			}
		}
		for {
			t = time.Date(int(year), time.Month(i), j, 0, 0, 0, 0, time.UTC)
			if t.Weekday() == 0 {
				fmt.Printf("%s: %d\n", time.Month(i), j)
				break
			}
			j = j - 1
		}
	}
}
