package main

import (
    "fmt"
    "math"
    "sort"
)

type Patient struct {
    id       int
    lastName string
}

// maps an id to a lastname
var patientDir = make(map[int]string)

// maintains a sorted list of ids
var patientIds []int

func patientNew(id int, lastName string) Patient {
    patientDir[id] = lastName
    patientIds = append(patientIds, id)
    sort.Ints(patientIds)
    return Patient{id, lastName}
}

type DS struct {
    dates  []string
    scores []float64
}

type Visit struct {
    id    int
    date  string
    score float64
}

// maps an id to lists of dates and scores
var visitDir = make(map[int]DS)

func visitNew(id int, date string, score float64) Visit {
    if date == "" {
        date = "0000-00-00"
    }
    v, ok := visitDir[id]
    if ok {
        v.dates = append(v.dates, date)
        v.scores = append(v.scores, score)
        visitDir[id] = DS{v.dates, v.scores}
    } else {
        visitDir[id] = DS{[]string{date}, []float64{score}}
    }
    return Visit{id, date, score}
}

type Merge struct{ id int }

func (m Merge) lastName() string  { return patientDir[m.id] }
func (m Merge) dates() []string   { return visitDir[m.id].dates }
func (m Merge) scores() []float64 { return visitDir[m.id].scores }

func (m Merge) lastVisit() string {
    dates := m.dates()
    dates2 := make([]string, len(dates))
    copy(dates2, dates)
    sort.Strings(dates2)
    return dates2[len(dates2)-1]
}

func (m Merge) scoreSum() float64 {
    sum := 0.0
    for _, score := range m.scores() {
        if score != -1 {
            sum += score
        }
    }
    return sum
}

func (m Merge) scoreAvg() float64 {
    count := 0
    for _, score := range m.scores() {
        if score != -1 {
            count++
        }
    }
    return m.scoreSum() / float64(count)
}

func mergePrint(merges []Merge) {
    fmt.Println("| PATIENT_ID | LASTNAME | LAST_VISIT | SCORE_SUM | SCORE_AVG |")
    f := "| %d       | %-7s  | %s | %4s      | %4s      |\n"
    for _, m := range merges {
        _, ok := visitDir[m.id]
        if ok {
            lv := m.lastVisit()
            if lv == "0000-00-00" {
                lv = "          "
            }
            scoreSum := m.scoreSum()
            ss := fmt.Sprintf("%4.1f", scoreSum)
            if scoreSum == 0 {
                ss = "    "
            }
            scoreAvg := m.scoreAvg()
            sa := "    "
            if !math.IsNaN(scoreAvg) {
                sa = fmt.Sprintf("%4.2f", scoreAvg)
            }
            fmt.Printf(f, m.id, m.lastName(), lv, ss, sa)
        } else {
            fmt.Printf(f, m.id, m.lastName(), "          ", "    ", "    ")
        }
    }
}

func main() {
    patientNew(1001, "Hopper")
    patientNew(4004, "Wirth")
    patientNew(3003, "Kemeny")
    patientNew(2002, "Gosling")
    patientNew(5005, "Kurtz")

    visitNew(2002, "2020-09-10", 6.8)
    visitNew(1001, "2020-09-17", 5.5)
    visitNew(4004, "2020-09-24", 8.4)
    visitNew(2002, "2020-10-08", -1) // -1 signifies no score
    visitNew(1001, "", 6.6)          // "" signifies no date
    visitNew(3003, "2020-11-12", -1)
    visitNew(4004, "2020-11-05", 7.0)
    visitNew(1001, "2020-11-19", 5.3)

    merges := make([]Merge, len(patientIds))
    for i, id := range patientIds {
        merges[i] = Merge{id}
    }
    mergePrint(merges)
}
