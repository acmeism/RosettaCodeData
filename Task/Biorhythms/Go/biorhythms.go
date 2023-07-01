package main

import (
    "fmt"
    "log"
    "math"
    "time"
)

const layout = "2006-01-02" // template for time.Parse

var cycles = [3]string{"Physical day ", "Emotional day", "Mental day   "}
var lengths = [3]int{23, 28, 33}
var quadrants = [4][2]string{
    {"up and rising", "peak"},
    {"up but falling", "transition"},
    {"down and falling", "valley"},
    {"down but rising", "transition"},
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

// Parameters assumed to be in YYYY-MM-DD format.
func biorhythms(birthDate, targetDate string) {
    bd, err := time.Parse(layout, birthDate)
    check(err)
    td, err := time.Parse(layout, targetDate)
    check(err)
    days := int(td.Sub(bd).Hours() / 24)
    fmt.Printf("Born %s, Target %s\n", birthDate, targetDate)
    fmt.Println("Day", days)
    for i := 0; i < 3; i++ {
        length := lengths[i]
        cycle := cycles[i]
        position := days % length
        quadrant := position * 4 / length
        percent := math.Sin(2 * math.Pi * float64(position) / float64(length))
        percent = math.Floor(percent*1000) / 10
        descript := ""
        if percent > 95 {
            descript = " peak"
        } else if percent < -95 {
            descript = " valley"
        } else if math.Abs(percent) < 5 {
            descript = " critical transition"
        } else {
            daysToAdd := (quadrant+1)*length/4 - position
            transition := td.Add(time.Hour * 24 * time.Duration(daysToAdd))
            trend := quadrants[quadrant][0]
            next := quadrants[quadrant][1]
            transStr := transition.Format(layout)
            descript = fmt.Sprintf("%5.1f%% (%s, next %s %s)", percent, trend, next, transStr)
        }
        fmt.Printf("%s %2d : %s\n", cycle, position, descript)
    }
    fmt.Println()
}

func main() {
    datePairs := [][2]string{
        {"1943-03-09", "1972-07-11"},
        {"1809-01-12", "1863-11-19"},
        {"1809-02-12", "1863-11-19"}, // correct DOB for Abraham Lincoln
    }
    for _, datePair := range datePairs {
        biorhythms(datePair[0], datePair[1])
    }
}
