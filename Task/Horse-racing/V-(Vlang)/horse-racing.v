struct Kv {
    key   string
    value []f64
}
fn main() {
    // ratings on past form, assuming a rating of 100 for horse A
    a := 100.0
    mut b := a - 8 - 2*2 // carried 8 lbs less, finished 2 lengths behind
    mut c := a + 4 - 2*3.5
    mut d := a - 4 - 10*0.4 // based on relative weight and time
    e := d + 7 - 2*1
    f := d + 11 - 2*(4-2)
    g := a - 10 + 10*0.2
    mut h := g + 6 - 2*1.5
    mut i := g + 15 - 2*2

    // adjustments to ratings for current race
    b += 4
    c -= 4
    h += 3
    mut j := a - 3 + 10*0.2

    // filly's allowance to give weight adjusted weighting
    b += 3
    d += 3
    i += 3
    j += 3

    // create map of horse to its weight adjusted rating and whether colt (1 == yes, 0 == no)
    m := {
        "A": [a, 1],
        "B": [b, 0],
        "C": [c, 1],
        "D": [d, 0],
        "E": [e, 1],
        "F": [f, 1],
        "G": [g, 1],
        "H": [h, 1],
        "I": [i, 0],
        "J": [j, 0],
    }

    // convert to slice of Kv
    mut l := []Kv{ len: m.len}
    mut x := 0
    for k, v in m {
        l[x] = Kv{k, v}
        x++
    }

    // sort in descending order of rating
    //sort.Slice(l, func(i, j int) bool { return l[i].value[0] > l[j].value[0] })
    l.sort_with_compare(fn(a &Kv, b &Kv) int {
        if a.value[0] < b.value[0] { return 1 }
        else if a.value[0] > b.value[0] { return -1 }
        return 0
    })
    // show expected result of race
    println("Race 4\n")
    println("Pos Horse  Weight  Dist  Sex")
    mut pos := ""
    for v in 0..l.len {
        mut wt := "9.00"
        if l[v].value[1] == 0 { wt = "8.11" }
        mut dist := 0.0
        if v > 0 { dist = (l[v-1].value[0]-l[v].value[0]) * 0.5 }
        if v == 0 || dist > 0.0 { pos = "${v+1}" }
        else {
            if pos.index('=') or {-1} < 0 { pos = "${v}=" }
        }
        mut sx := "colt"
        if l[v].value[1] == 0 { sx = "filly" }
        println("${pos:-2}  ${l[v].key}      $wt    ${dist:3.1f}   $sx")
    }

    // weight adjusted rating of winner
    wr := l[0].value[0]

    // expected time of winner (relative to A's time in Race 1)
    t := 96.0 - (wr-100)/10
    min := int(t / 60)
    sec := t - f64(min)*60
    println("\nTime $min minute ${sec:3.1f} seconds")
}
