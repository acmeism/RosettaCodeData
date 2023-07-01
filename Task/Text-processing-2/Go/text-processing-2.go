package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
	"time"
)

const (
	filename   = "readings.txt"
	readings   = 24             // per line
	fields     = readings*2 + 1 // per line
	dateFormat = "2006-01-02"
)

func main() {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	var allGood, uniqueGood int
	// map records not only dates seen, but also if an all-good record was
	// seen for the key date.
	m := make(map[time.Time]bool)
	s := bufio.NewScanner(file)
	for s.Scan() {
		f := strings.Fields(s.Text())
		if len(f) != fields {
			log.Fatal("unexpected format,", len(f), "fields.")
		}
		ts, err := time.Parse(dateFormat, f[0])
		if err != nil {
			log.Fatal(err)
		}
		good := true
		for i := 1; i < fields; i += 2 {
			flag, err := strconv.Atoi(f[i+1])
			if err != nil {
				log.Fatal(err)
			}
			if flag > 0 { // value is good
				_, err := strconv.ParseFloat(f[i], 64)
				if err != nil {
					log.Fatal(err)
				}
			} else { // value is bad
				good = false
			}
		}
		if good {
			allGood++
		}
		previouslyGood, seen := m[ts]
		if seen {
			fmt.Println("Duplicate datestamp:", f[0])
		}
		m[ts] = previouslyGood || good
		if !previouslyGood && good {
			uniqueGood++
		}
	}
	if err := s.Err(); err != nil {
		log.Fatal(err)
	}

	fmt.Println("\nData format valid.")
	fmt.Println(allGood, "records with good readings for all instruments.")
	fmt.Println(uniqueGood,
		"unique dates with good readings for all instruments.")
}
