// 99 bottles of V
module main

// pluralize
fn plural(beers int) string {
    if beers == 1 { return "" } else { return "s" }
}

// The repetitive song
fn verse(beers int) {
    mut beer := beers - 1
    mut numno := beers.str()
    mut elipsis := ""

    if beers == 0 { numno = "No" }
    println("$numno bottle${plural(beers)} of beer on the wall")
    println("$numno bottle${plural(beers)} of beer")
    if beer == 0 { numno = "No" } else { numno = beer.str() }
    if beers == 0 {
        println("To the store, to buy some more")
        numno = "99"
        elipsis = "..."
    } else {
        println("Take one down, pass it around")
    }
    println("$numno bottle${plural(beer)} of beer on the wall${elipsis}")
}

// passing time
pub fn main() {
    for beers := 99; beers >= 0; beers-- {
        verse(beers)
        println("")
    }
}
