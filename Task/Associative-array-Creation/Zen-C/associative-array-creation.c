import "std/map.zc"

fn print_map(m: Map<string>*) {
    for entry in *m {
        print "{{{entry.key}: {entry.val}}}, ";
    }
    println "\b\b ";
}

fn main() {
    let fruit = Map<string>::new(); // creates an empty map
    fruit.put("1", "orange");       // associates a key of "1" with "orange"
    fruit.put("2", "apple");        // associates a key of "2" with "apple"
    let f = fruit["1"].unwrap();    // retrieves the value with a key of "1"
    println "{f}";                  // and prints it out
    fruit.remove("1");              // removes the entry with a key of "1" from the map
    print_map(&fruit);              // prints the rest of the map
    println "";

    let capitals = Map<string>::new();   // creates a new map with four entries
    capitals.put("France","Paris");
    capitals.put("Germany", "Berlin");
    capitals.put("Spain", "Madrid");
    capitals.put("Russia", "Moscow");
    let c = capitals["France"].unwrap(); // retrieves the "France" entry
    println "{c}";                       // and prints out its capital
    capitals.remove("France")            // removes the "France" entry
    print_map(&capitals);                // prints all remaining entries
    println "{capitals.length()}"        // prints the number of remaining entries
    c = capitals["Sweden"].unwrap_or("none");
    println "{c}"                        // prints the entry for Sweden (none as there isn't one)
}
