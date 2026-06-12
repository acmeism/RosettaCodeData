package main

import "fmt"

const (
    right    = 1
    left     = -1
    straight = 0
)

func normalize(tracks []int) string {
    size := len(tracks)
    a := make([]byte, size)
    for i := 0; i < size; i++ {
        a[i] = "abc"[tracks[i]+1]
    }

    /* Rotate the array and find the lexicographically lowest order
       to allow the hashmap to weed out duplicate solutions. */

    norm := string(a)
    for i := 0; i < size; i++ {
        s := string(a)
        if s < norm {
            norm = s
        }
        tmp := a[0]
        copy(a, a[1:])
        a[size-1] = tmp
    }
    return norm
}

func fullCircleStraight(tracks []int, nStraight int) bool {
    if nStraight == 0 {
        return true
    }

    // do we have the requested number of straight tracks
    count := 0
    for _, track := range tracks {
        if track == straight {
            count++
        }
    }
    if count != nStraight {
        return false
    }

    // check symmetry of straight tracks: i and i + 6, i and i + 4
    var straightTracks [12]int
    for i, idx := 0, 0; i < len(tracks) && idx >= 0; i++ {
        if tracks[i] == straight {
            straightTracks[idx%12]++
        }
        idx += tracks[i]
    }
    any1, any2 := false, false
    for i := 0; i <= 5; i++ {
        if straightTracks[i] != straightTracks[i+6] {
            any1 = true
            break
        }
    }
    for i := 0; i <= 7; i++ {
        if straightTracks[i] != straightTracks[i+4] {
            any2 = true
            break
        }
    }
    return !any1 || !any2
}

func fullCircleRight(tracks []int) bool {
    // all tracks need to add up to a multiple of 360
    sum := 0
    for _, track := range tracks {
        sum += track * 30
    }
    if sum%360 != 0 {
        return false
    }

    // check symmetry of right turns: i and i + 6, i and i + 4
    var rTurns [12]int
    for i, idx := 0, 0; i < len(tracks) && idx >= 0; i++ {
        if tracks[i] == right {
            rTurns[idx%12]++
        }
        idx += tracks[i]
    }
    any1, any2 := false, false
    for i := 0; i <= 5; i++ {
        if rTurns[i] != rTurns[i+6] {
            any1 = true
            break
        }
    }
    for i := 0; i <= 7; i++ {
        if rTurns[i] != rTurns[i+4] {
            any2 = true
            break
        }
    }
    return !any1 || !any2
}

func circuits(nCurved, nStraight int) {
    solutions := make(map[string][]int)
    gen := getPermutationsGen(nCurved, nStraight)
    for gen.hasNext() {
        tracks := gen.next()
        if !fullCircleStraight(tracks, nStraight) {
            continue
        }
        if !fullCircleRight(tracks) {
            continue
        }
        tracks2 := make([]int, len(tracks))
        copy(tracks2, tracks)
        solutions[normalize(tracks)] = tracks2
    }
    report(solutions, nCurved, nStraight)
}

func getPermutationsGen(nCurved, nStraight int) PermutationsGen {
    if (nCurved+nStraight-12)%4 != 0 {
        panic("input must be 12 + k * 4")
    }
    var trackTypes []int
    switch nStraight {
    case 0:
        trackTypes = []int{right, left}
    case 12:
        trackTypes = []int{right, straight}
    default:
        trackTypes = []int{right, left, straight}
    }
    return NewPermutationsGen(nCurved+nStraight, trackTypes)
}

func report(sol map[string][]int, numC, numS int) {
    size := len(sol)
    fmt.Printf("\n%d solution(s) for C%d,%d \n", size, numC, numS)
    if numC <= 20 {
        for _, tracks := range sol {
            for _, track := range tracks {
                fmt.Printf("%2d ", track)
            }
            fmt.Println()
        }
    }
}

// not thread safe
type PermutationsGen struct {
    NumPositions int
    choices      []int
    indices      []int
    sequence     []int
    carry        int
}

func NewPermutationsGen(numPositions int, choices []int) PermutationsGen {
    indices := make([]int, numPositions)
    sequence := make([]int, numPositions)
    carry := 0
    return PermutationsGen{numPositions, choices, indices, sequence, carry}
}

func (p *PermutationsGen) next() []int {
    p.carry = 1

    /* The generator skips the first index, so the result will always start
       with a right turn (0) and we avoid clockwise/counter-clockwise
       duplicate solutions. */
    for i := 1; i < len(p.indices) && p.carry > 0; i++ {
        p.indices[i] += p.carry
        p.carry = 0
        if p.indices[i] == len(p.choices) {
            p.carry = 1
            p.indices[i] = 0
        }
    }
    for j := 0; j < len(p.indices); j++ {
        p.sequence[j] = p.choices[p.indices[j]]
    }
    return p.sequence
}

func (p *PermutationsGen) hasNext() bool {
    return p.carry != 1
}

func main() {
    for n := 12; n <= 28; n += 4 {
        circuits(n, 0)
    }
    circuits(12, 4)
}
