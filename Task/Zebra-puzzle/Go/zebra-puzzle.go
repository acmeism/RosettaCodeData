package main

import (
        "fmt"
        "log"
        "strings"
)

// Define some types

type HouseSet [5]*House
type House struct {
        n Nationality
        c Colour
        a Animal
        d Drink
        s Smoke
}
type Nationality int8
type Colour int8
type Animal int8
type Drink int8
type Smoke int8

// Define the possible values

const (
        English Nationality = iota
        Swede
        Dane
        Norwegian
        German
)
const (
        Red Colour = iota
        Green
        White
        Yellow
        Blue
)
const (
        Dog Animal = iota
        Birds
        Cats
        Horse
        Zebra
)
const (
        Tea Drink = iota
        Coffee
        Milk
        Beer
        Water
)
const (
        PallMall Smoke = iota
        Dunhill
        Blend
        BlueMaster
        Prince
)

// And how to print them

var nationalities = [...]string{"English", "Swede", "Dane", "Norwegian", "German"}
var colours = [...]string{"red", "green", "white", "yellow", "blue"}
var animals = [...]string{"dog", "birds", "cats", "horse", "zebra"}
var drinks = [...]string{"tea", "coffee", "milk", "beer", "water"}
var smokes = [...]string{"Pall Mall", "Dunhill", "Blend", "Blue Master", "Prince"}

func (n Nationality) String() string { return nationalities[n] }
func (c Colour) String() string      { return colours[c] }
func (a Animal) String() string      { return animals[a] }
func (d Drink) String() string       { return drinks[d] }
func (s Smoke) String() string       { return smokes[s] }
func (h House) String() string {
        return fmt.Sprintf("%-9s  %-6s  %-5s  %-6s  %s", h.n, h.c, h.a, h.d, h.s)
}
func (hs HouseSet) String() string {
        lines := make([]string, 0, len(hs))
        for i, h := range hs {
                s := fmt.Sprintf("%d  %s", i, h)
                lines = append(lines, s)
        }
        return strings.Join(lines, "\n")
}

// Simple brute force solution

func simpleBruteForce() (int, HouseSet) {
        var v []House
        for n := range nationalities {
                for c := range colours {
                        for a := range animals {
                                for d := range drinks {
                                        for s := range smokes {
                                                h := House{
                                                        n: Nationality(n),
                                                        c: Colour(c),
                                                        a: Animal(a),
                                                        d: Drink(d),
                                                        s: Smoke(s),
                                                }
                                                if !h.Valid() {
                                                        continue
                                                }
                                                v = append(v, h)
                                        }
                                }
                        }
                }
        }
        n := len(v)
        log.Println("Generated", n, "valid houses")

        combos := 0
        first := 0
        valid := 0
        var validSet HouseSet
        for a := 0; a < n; a++ {
                if v[a].n != Norwegian { // Condition 10:
                        continue
                }
                for b := 0; b < n; b++ {
                        if b == a {
                                continue
                        }
                        if v[b].anyDups(&v[a]) {
                                continue
                        }
                        for c := 0; c < n; c++ {
                                if c == b || c == a {
                                        continue
                                }
                                if v[c].d != Milk { // Condition 9:
                                        continue
                                }
                                if v[c].anyDups(&v[b], &v[a]) {
                                        continue
                                }
                                for d := 0; d < n; d++ {
                                        if d == c || d == b || d == a {
                                                continue
                                        }
                                        if v[d].anyDups(&v[c], &v[b], &v[a]) {
                                                continue
                                        }
                                        for e := 0; e < n; e++ {
                                                if e == d || e == c || e == b || e == a {
                                                        continue
                                                }
                                                if v[e].anyDups(&v[d], &v[c], &v[b], &v[a]) {
                                                        continue
                                                }
                                                combos++
                                                set := HouseSet{&v[a], &v[b], &v[c], &v[d], &v[e]}
                                                if set.Valid() {
                                                        valid++
                                                        if valid == 1 {
                                                                first = combos
                                                        }
                                                        validSet = set
                                                        //return set
                                                }
                                        }
                                }
                        }
                }
        }
        log.Println("Tested", first, "different combinations of valid houses before finding solution")
        log.Println("Tested", combos, "different combinations of valid houses in total")
        return valid, validSet
}

// anyDups returns true if h as any duplicate attributes with any of the specified houses
func (h *House) anyDups(list ...*House) bool {
        for _, b := range list {
                if h.n == b.n || h.c == b.c || h.a == b.a || h.d == b.d || h.s == b.s {
                        return true
                }
        }
        return false
}

func (h *House) Valid() bool {
        // Condition 2:
        if h.n == English && h.c != Red || h.n != English && h.c == Red {
                return false
        }
        // Condition 3:
        if h.n == Swede && h.a != Dog || h.n != Swede && h.a == Dog {
                return false
        }
        // Condition 4:
        if h.n == Dane && h.d != Tea || h.n != Dane && h.d == Tea {
                return false
        }
        // Condition 6:
        if h.c == Green && h.d != Coffee || h.c != Green && h.d == Coffee {
                return false
        }
        // Condition 7:
        if h.a == Birds && h.s != PallMall || h.a != Birds && h.s == PallMall {
                return false
        }
        // Condition 8:
        if h.c == Yellow && h.s != Dunhill || h.c != Yellow && h.s == Dunhill {
                return false
        }
        // Condition 11:
        if h.a == Cats && h.s == Blend {
                return false
        }
        // Condition 12:
        if h.a == Horse && h.s == Dunhill {
                return false
        }
        // Condition 13:
        if h.d == Beer && h.s != BlueMaster || h.d != Beer && h.s == BlueMaster {
                return false
        }
        // Condition 14:
        if h.n == German && h.s != Prince || h.n != German && h.s == Prince {
                return false
        }
        // Condition 15:
        if h.n == Norwegian && h.c == Blue {
                return false
        }
        // Condition 16:
        if h.d == Water && h.s == Blend {
                return false
        }
        return true
}

func (hs *HouseSet) Valid() bool {
        ni := make(map[Nationality]int, 5)
        ci := make(map[Colour]int, 5)
        ai := make(map[Animal]int, 5)
        di := make(map[Drink]int, 5)
        si := make(map[Smoke]int, 5)
        for i, h := range hs {
                ni[h.n] = i
                ci[h.c] = i
                ai[h.a] = i
                di[h.d] = i
                si[h.s] = i
        }
        // Condition 5:
        if ci[Green]+1 != ci[White] {
                return false
        }
        // Condition 11:
        if dist(ai[Cats], si[Blend]) != 1 {
                return false
        }
        // Condition 12:
        if dist(ai[Horse], si[Dunhill]) != 1 {
                return false
        }
        // Condition 15:
        if dist(ni[Norwegian], ci[Blue]) != 1 {
                return false
        }
        // Condition 16:
        if dist(di[Water], si[Blend]) != 1 {
                return false
        }

        // Condition 9: (already tested elsewhere)
        if hs[2].d != Milk {
                return false
        }
        // Condition 10: (already tested elsewhere)
        if hs[0].n != Norwegian {
                return false
        }
        return true
}

func dist(a, b int) int {
        if a > b {
                return a - b
        }
        return b - a
}

func main() {
        log.SetFlags(0)
        n, sol := simpleBruteForce()
        fmt.Println(n, "solution found")
        fmt.Println(sol)
}
