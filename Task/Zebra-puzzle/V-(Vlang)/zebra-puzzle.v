type HouseSet = []House
struct House {
    n Nationality
    c Colour
    a Animal
    d Drink
    s Smoke
}

// Define the possible values
enum Nationality {
    english = 0
    swede
    dane
    norwegian
    german
}
enum Colour {
    red = 0
    green
    white
    yellow
    blue
}
enum Animal {
    dog = 0
    birds
    cats
    horse
    zebra
}
enum Drink {
    tea = 0
    coffee
    milk
    beer
    water
}
enum Smoke {
    pall_mall = 0
    dunhill
    blend
    blue_master
    prince
}

// And how to print them

const nationalities = [Nationality.english, Nationality.swede, Nationality.dane, Nationality.norwegian, Nationality.german]
const colours = [Colour.red, Colour.green, Colour.white, Colour.yellow, Colour.blue]
const animals = [Animal.dog, Animal.birds, Animal.cats, Animal.horse, Animal.zebra]
const drinks = [Drink.tea, Drink.coffee, Drink.milk, Drink.beer, Drink.water]
const smokes = [Smoke.pall_mall, Smoke.dunhill, Smoke.blend, Smoke.blue_master, Smoke.prince]

fn (h House) str() string {
        return "${h.n:-9}  ${h.c:-6}  ${h.a:-5}  ${h.d:-6}  $h.s"
}
fn (hs HouseSet) str() string {
        mut lines := []string{len: 0, cap: 5}
        for i, h in hs {
                s := "$i  $h"
                lines << s
        }
        return lines.join("\n")
}

// Simple brute force solution

fn simple_brute_force() (int, HouseSet) {
        mut v := []House{}
        for n in nationalities {
                for c in colours {
                        for a in animals {
                                for d in drinks {
                                        for s in smokes {
                                                h := House{
                                                        n: n,
                                                        c: c,
                                                        a: a,
                                                        d: d,
                                                        s: s,
                                                }
                                                if !h.valid() {
                                                        continue
                                                }
                                                v << h
                                        }
                                }
                        }
                }
        }
        n := v.len
        println("Generated $n valid houses")

        mut combos := 0
        mut first := 0
        mut valid := 0
        mut valid_set := []House{}
        for a := 0; a < n; a++ {
            if v[a].n != Nationality.norwegian { // Condition 10:
                continue
            }
            for b := 0; b < n; b++ {
                if b == a {
                    continue
                }
                if v[b].any_dups(v[a]) {
                    continue
                }
                for c := 0; c < n; c++ {
                        if c == b || c == a {
                            continue
                        }
                        if v[c].d != Drink.milk { // Condition 9:
                            continue
                        }
                        if v[c].any_dups(v[b], v[a]) {
                            continue
                        }
                        for d := 0; d < n; d++ {
                                if d == c || d == b || d == a {
                                    continue
                                }
                                if v[d].any_dups(v[c], v[b], v[a]) {
                                    continue
                                }
                                for e := 0; e < n; e++ {
                                    if e == d || e == c || e == b || e == a {
                                        continue
                                    }
                                    if v[e].any_dups(v[d], v[c], v[b], v[a]) {
                                        continue
                                    }
                                    combos++
                                    set := HouseSet([v[a], v[b], v[c], v[d], v[e]])
                                    if set.valid() {
                                        valid++
                                        if valid == 1 {
                                                first = combos
                                        }
                                        valid_set = set
                                        //return set
                                    }
                                }
                        }
                }
            }
        }
        println("Tested $first different combinations of valid houses before finding solution")
        println("Tested $combos different combinations of valid houses in total")
        return valid, valid_set
}

// any_dups returns true if h as any duplicate attributes with any of the specified houses
fn (h House) any_dups(list ...House) bool {
    for b in list {
        if h.n == b.n || h.c == b.c || h.a == b.a || h.d == b.d || h.s == b.s {
            return true
        }
    }
    return false
}

fn (h House) valid() bool {
    // Condition 2:
    if (h.n == Nationality.english && h.c != Colour.red) || (h.n != Nationality.english && h.c == Colour.red) {
        return false
    }
    // Condition 3:
    if (h.n == Nationality.swede && h.a != Animal.dog) || (h.n != Nationality.swede && h.a == Animal.dog) {
        return false
    }
    // Condition 4:
    if (h.n == Nationality.dane && h.d != Drink.tea) || (h.n != Nationality.dane && h.d == Drink.tea ){
        return false
    }
    // Condition 6:
    if (h.c == Colour.green && h.d != Drink.coffee) || (h.c != Colour.green && h.d == Drink.coffee) {
        return false
    }
    // Condition 7:
    if (h.a == Animal.birds && h.s != Smoke.pall_mall) || (h.a != Animal.birds && h.s == Smoke.pall_mall) {
        return false
    }
    // Condition 8:
    if (h.c == Colour.yellow && h.s != Smoke.dunhill) || (h.c != Colour.yellow && h.s == Smoke.dunhill) {
        return false
    }
    // Condition 11:
    if h.a == Animal.cats && h.s == Smoke.blend {
        return false
    }
    // Condition 12:
    if h.a == Animal.horse && h.s == Smoke.dunhill {
        return false
    }
    // Condition 13:
    if (h.d == Drink.beer && h.s != Smoke.blue_master) || (h.d != Drink.beer && h.s == Smoke.blue_master) {
        return false
    }
    // Condition 14:
    if (h.n == Nationality.german && h.s != Smoke.prince) || (h.n != Nationality.german && h.s == Smoke.prince) {
        return false
    }
    // Condition 15:
    if h.n == Nationality.norwegian && h.c == Colour.blue {
        return false
    }
    // Condition 16:
    if h.d == Drink.water && h.s == Smoke.blend {
        return false
    }
    return true
}

fn (hs HouseSet) valid() bool {
    mut ni := map[Nationality]int{}
    mut ci := map[Colour]int{}
    mut ai := map[Animal]int{}
    mut di := map[Drink]int{}
    mut si := map[Smoke]int{}
    for i, h in hs {
            ni[h.n] = i
            ci[h.c] = i
            ai[h.a] = i
            di[h.d] = i
            si[h.s] = i
    }
    // Condition 5:
    if ci[Colour.green]+1 != ci[Colour.white] {
            return false
    }
    // Condition 11:
    if dist(ai[Animal.cats], si[Smoke.blend]) != 1 {
            return false
    }
    // Condition 12:
    if dist(ai[Animal.horse], si[Smoke.dunhill]) != 1 {
            return false
    }
    // Condition 15:
    if dist(ni[Nationality.norwegian], ci[Colour.blue]) != 1 {
            return false
    }
    // Condition 16:
    if dist(di[Drink.water], si[Smoke.blend]) != 1 {
            return false
    }

    // Condition 9: (already tested elsewhere)
    if hs[2].d != Drink.milk {
            return false
    }
    // Condition 10: (already tested elsewhere)
    if hs[0].n != Nationality.norwegian {
            return false
    }
    return true
}

fn dist(a int, b int) int {
    if a > b {
        return a - b
    }
    return b - a
}

fn main() {
    n, sol := simple_brute_force()
    println("$n solution found")
    println(sol)
}
