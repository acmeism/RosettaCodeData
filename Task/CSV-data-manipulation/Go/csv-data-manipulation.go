package main

import (
	"encoding/csv"
	"io"
	"log"
	"os"
	"strconv"
)

func init() {
	log.SetFlags(log.Lshortfile)
}

func main() {
	// Open the sample file given.
	csvFile, err := os.Open("sample.csv")

	// Exit on error.
	if err != nil {
		log.Fatal("Error opening sample csv file:", err)
	}

	// Make sure the file is closed before the function returns.
	defer csvFile.Close()

	// Create a new csv reader for the file.
	csvReader := csv.NewReader(csvFile)

	// Create an output file.
	outputFile, err := os.Create("output.csv")
	if err != nil {
		log.Fatal("Error creating output file:", err)
	}
	defer outputFile.Close()

	csvWriter := csv.NewWriter(outputFile)
	defer csvWriter.Flush()

	// For each row in the data.
	for i := 0; ; i++ {
		record, err := csvReader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal("Error reading record:", err)
		}

		// Skip header row.
		if i == 0 {
			err = csvWriter.Write(record)
			if err != nil {
				log.Fatal("Error writing record to output file:", err)
			}
			continue
		}

		// For each cell in the row.
		for cell := range record {
			// Convert value to integer for manipulation.
			v, err := strconv.Atoi(record[cell])
			if err != nil {
				log.Fatal("Error parsing cell value:", err)
			}

			// Do something to the value.
			v += 1
			// Store the new value back in the record variable.
			record[cell] = strconv.Itoa(v)
		}

		// Write modified record to disk.
		err = csvWriter.Write(record)
		if err != nil {
			log.Fatal("Error writing record to output file:", err)
		}
	}
}
