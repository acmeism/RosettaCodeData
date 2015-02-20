package main

import (
    "fmt"
    "unicode"
)

var states = []string{"Alabama", "Alaska", "Arizona", "Arkansas",
    "California", "Colorado", "Connecticut",
    "Delaware",
    "Florida", "Georgia", "Hawaii",
    "Idaho", "Illinois", "Indiana", "Iowa",
    "Kansas", "Kentucky", "Louisiana",
    "Maine", "Maryland", "Massachusetts", "Michigan",
    "Minnesota", "Mississippi", "Missouri", "Montana",
    "Nebraska", "Nevada", "New Hampshire", "New Jersey",
    "New Mexico", "New York", "North Carolina", "North Dakota",
    "Ohio", "Oklahoma", "Oregon",
    "Pennsylvania", "Rhode Island",
    "South Carolina", "South Dakota", "Tennessee", "Texas",
    "Utah", "Vermont", "Virginia",
    "Washington", "West Virginia", "Wisconsin", "Wyoming"}

func main() {
    play(states)
    play(append(states,
        "New Kory", "Wen Kory", "York New", "Kory New", "New Kory"))
}

func play(states []string) {
    fmt.Println(len(states), "states:")
    // get list of unique state names
    set := make(map[string]bool, len(states))
    for _, s := range states {
        set[s] = true
    }
    // make parallel arrays for unique state names and letter histograms
    s := make([]string, len(set))
    h := make([][26]byte, len(set))
    var i int
    for us := range set {
        s[i] = us
        for _, c := range us {
            if u := uint(unicode.ToLower(c)) - 'a'; u < 26 {
                h[i][u]++
            }
        }
        i++
    }
    // use map to find matches.  map key is sum of histograms of
    // two different states.  map value is indexes of the two states.
    type pair struct {
        i1, i2 int
    }
    m := make(map[string][]pair)
    b := make([]byte, 26) // buffer for summing histograms
    for i1, h1 := range h {
        for i2 := i1 + 1; i2 < len(h); i2++ {
            // sum histograms
            for i := range b {
                b[i] = h1[i] + h[i2][i]
            }
            k := string(b) // make key from buffer.
            // now loop over any existing pairs with the same key,
            // printing any where both states of this pair are different
            // than the states of the existing pair
            for _, x := range m[k] {
                if i1 != x.i1 && i1 != x.i2 && i2 != x.i1 && i2 != x.i2 {
                    fmt.Printf("%s, %s = %s, %s\n", s[i1], s[i2],
                        s[x.i1], s[x.i2])
                }
            }
            // store this pair in the map whether printed or not.
            m[k] = append(m[k], pair{i1, i2})
        }
    }
}
