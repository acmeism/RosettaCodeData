package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

const (
	filename = "readings.txt"
	readings = 24             // per line
	fields   = readings*2 + 1 // per line
)

func main() {
	file, err := os.Open(filename)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()
	var (
		badRun, maxRun   int
		badDate, maxDate string
		fileSum          float64
		fileAccept       int
	)
	endBadRun := func() {
		if badRun > maxRun {
			maxRun = badRun
			maxDate = badDate
		}
		badRun = 0
	}
	s := bufio.NewScanner(file)
	for s.Scan() {
		f := strings.Fields(s.Text())
		if len(f) != fields {
			log.Fatal("unexpected format,", len(f), "fields.")
		}
		var accept int
		var sum float64
		for i := 1; i < fields; i += 2 {
			flag, err := strconv.Atoi(f[i+1])
			if err != nil {
				log.Fatal(err)
			}
			if flag <= 0 { // value is bad
				if badRun++; badRun == 1 {
					badDate = f[0]
				}
			} else { // value is good
				endBadRun()
				value, err := strconv.ParseFloat(f[i], 64)
				if err != nil {
					log.Fatal(err)
				}
				sum += value
				accept++
			}
		}
		fmt.Printf("Line: %s  Reject %2d  Accept: %2d  Line_tot:%9.3f",
			f[0], readings-accept, accept, sum)
		if accept > 0 {
			fmt.Printf("  Line_avg:%8.3f\n", sum/float64(accept))
		} else {
			fmt.Println()
		}
		fileSum += sum
		fileAccept += accept
	}
	if err := s.Err(); err != nil {
		log.Fatal(err)
	}
	endBadRun()

	fmt.Println("\nFile     =", filename)
	fmt.Printf("Total    = %.3f\n", fileSum)
	fmt.Println("Readings = ", fileAccept)
	if fileAccept > 0 {
		fmt.Printf("Average  =  %.3f\n", fileSum/float64(fileAccept))
	}
	if maxRun == 0 {
		fmt.Println("\nAll data valid.")
	} else {
		fmt.Printf("\nMax data gap = %d, beginning on line %s.\n",
			maxRun, maxDate)
	}
}
