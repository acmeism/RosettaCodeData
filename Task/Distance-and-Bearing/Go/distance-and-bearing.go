package main

import (
	"fmt"
	"bufio"
	"strings"
	"io"
	"os"
	"strconv"
	"math"
	"sort"
)

//Structure to store airport information.
type airport struct {
	name string
	country string
	code string
	lat float64
	long float64
	dist float64
	brg int
}

func newAirport(name string, country string, code string, lat float64, long float64) *airport {
	a := airport{name: name, country: country, code: code, lat: lat, long: long, dist: 0.0, brg: 0}

	return &a
}


//Generic error checker.
func check(e error) {
    if e != nil {
        panic(e)
    }
}

//Removes the first and last characters of a string.
func cleanStr(s string) string {
	return s[1 : len(s)-1]
}


func main() {
	const lat = 51.514669
	const long = 2.198581

	airports := getAirports(lat, long)
	//Sort according to the distance.
	sort.Slice(airports, func(i, j int) bool {
	  return airports[i].dist < airports[j].dist
	})

	fmt.Printf("%9s %8s  %s %20s %50s\n", "Distance", "Bearing", "ICAO", "Country", "Airport")
	for i, a := range airports {
		if (i >= 20) {
			break
		}

		printAirport(a)
	}
}

//Reads the data file and returns a list of structures with the relevant information.
func getAirports(lat float64, long float64) []*airport {
	var airportLst []*airport

	f, err := os.Open("airports.dat")
	check(err)
	defer closeFile(f)

	reader := bufio.NewReader(f)

	for {
		line, err := reader.ReadString('\n')
		//Check for EOF, otherwise check for errors.
		if err == io.EOF {
			break
		}
		check(err)

		//Extract information from line.
		splitLine := strings.Split(line, ",")
		name, country, code := splitLine[1], splitLine[3], splitLine[5]
		var airportLat, airportLong float64
		//We don't need to worry about conversion errors, the numbers are well formatted in the file.
		airportLat, _ = strconv.ParseFloat(splitLine[6], 64)
		airportLong, _ = strconv.ParseFloat(splitLine[7], 64)

		airport := newAirport(cleanStr(name), cleanStr(country), cleanStr(code), airportLat, airportLong)
		airport.dist, airport.brg = getInfo(lat, long, airport.lat, airport.long)

		airportLst = append(airportLst, airport)
	}

	return airportLst
}

func closeFile(f *os.File) {
    err := f.Close()
    check(err)
}

func printAirport(a *airport) {
	fmt.Printf("%9.1f %8d  %s %20s %50s\n", a.dist, a.brg, a.code, a.country, a.name)
}

//Get distance and initial bearing between the specified points.
func getInfo(lat1 float64, long1 float64, lat2 float64, long2 float64) (float64, int) {
	const deg2rad = math.Pi / 180

	//Distance calculation.
	phi1 := lat1 * deg2rad
	phi2 := lat2 * deg2rad
	deltaLat := (lat2 - lat1) * deg2rad
	deltaLong := (long2 - long1) * deg2rad

	a := math.Sin(deltaLat/2) * math.Sin(deltaLat/2) + math.Cos(phi1) * math.Cos(phi2) * math.Sin(deltaLong/2) * math.Sin(deltaLong/2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1 - a))
	dist := 3440 * c

	//Bearing calculation.
	y := math.Sin(deltaLong) * math.Cos(phi2)
	x := math.Cos(phi1) * math.Sin(phi2) - math.Sin(phi1) * math.Cos(phi2) * math.Cos(deltaLong)

	angle := math.Atan2(y, x)
	brg := int(math.Mod(angle * (180 / math.Pi) + 360, 360))

	return dist, brg
}
