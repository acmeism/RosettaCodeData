package main

import "core:fmt"
import "core:time"

main :: proc() {
	now := time.now()
	year, month, day := time.date(now)

	weekday := time.weekday(now)

	fmt.printfln("%d-%2d-%2d", year, month, day)
	fmt.printfln("%s, %s %2d, %d", weekday, month, day, year)
}
