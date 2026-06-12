package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
	"time"
)

const LAYOUT = "15:04:05,000"

func forwardTime(timeString string, seconds int) string {
	timeString = strings.TrimSpace(timeString)
	t, err := time.Parse(LAYOUT, timeString)

	if err != nil {
		panic(err)
	}

	t = t.Add(time.Second * time.Duration(seconds))

	return t.Format(LAYOUT)
}

func forwardSubtitles(titleFile string, seconds int) {
	f, err := os.Open(titleFile)

	if err != nil {
		panic(err)
	}

	scanner := bufio.NewScanner(f)
	visitedTime := false

	for scanner.Scan() {
		line := scanner.Text()

		if len(line) == 0 {
			fmt.Println()
			visitedTime = false
			continue
		}

		if !visitedTime && strings.Contains(line, "-->") {
			split := strings.Split(line, "-->")
			fmt.Println(forwardTime(split[0], seconds), "-->", forwardTime(split[1], seconds))
			visitedTime = true
			continue
		}

		fmt.Println(line)
	}

	fmt.Println()
}

func main() {
	fmt.Println("After fast-forwarding 9 seconds:")
	forwardSubtitles("movie.srt", 9)
	fmt.Println("After rolling-back 9 seconds:")
	forwardSubtitles("movie.srt", -9)
}
