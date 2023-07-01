package main

import (
	"fmt"
	"time"
)

const pageWidth = 80

func main() {
	printCal(1969)
}

func printCal(year int) {
	thisDate := time.Date(year, 1, 1, 1, 1, 1, 1, time.UTC)
	var (
		dayArr                  [12][7][6]int // month, weekday, week
		month, lastMonth        time.Month
		weekInMonth, dayInMonth int
	)
	for thisDate.Year() == year {
		if month = thisDate.Month(); month != lastMonth {
			weekInMonth = 0
			dayInMonth = 1
		}
		weekday := thisDate.Weekday()
		if weekday == 0 && dayInMonth > 1 {
			weekInMonth++
		}
		dayArr[int(month)-1][weekday][weekInMonth] = thisDate.Day()
		lastMonth = month
		dayInMonth++
		thisDate = thisDate.Add(time.Hour * 24)
	}
	centre := fmt.Sprintf("%d", pageWidth/2)
	fmt.Printf("%"+centre+"s\n\n", "[SNOOPY]")
	centre = fmt.Sprintf("%d", pageWidth/2-2)
	fmt.Printf("%"+centre+"d\n\n", year)
	months := [12]string{
		" January ", " February", "  March  ", "  April  ",
		"   May   ", "   June  ", "   July  ", "  August ",
		"September", " October ", " November", " December"}
	days := [7]string{"Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"}
	for qtr := 0; qtr < 4; qtr++ {
		for monthInQtr := 0; monthInQtr < 3; monthInQtr++ { // Month names
			fmt.Printf("      %s           ", months[qtr*3+monthInQtr])
		}
		fmt.Println()
		for monthInQtr := 0; monthInQtr < 3; monthInQtr++ { // Day names
			for day := 0; day < 7; day++ {
				fmt.Printf(" %s", days[day])
			}
			fmt.Printf("     ")
		}
		fmt.Println()
		for weekInMonth = 0; weekInMonth < 6; weekInMonth++ {
			for monthInQtr := 0; monthInQtr < 3; monthInQtr++ {
				for day := 0; day < 7; day++ {
					if dayArr[qtr*3+monthInQtr][day][weekInMonth] == 0 {
						fmt.Printf("   ")
					} else {
						fmt.Printf("%3d", dayArr[qtr*3+monthInQtr][day][weekInMonth])
					}
				}
				fmt.Printf("     ")
			}
			fmt.Println()
		}
		fmt.Println()
	}
}
