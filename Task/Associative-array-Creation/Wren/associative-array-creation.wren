var fruit = {}                   // creates an empty map
fruit[1] = "orange"              // associates a key of 1 with "orange"
fruit[2] = "apple"               // associates a key of 2 with "apple"
System.print(fruit[1])           // retrieves the value with a key of 1 and prints it out
fruit.remove(1)                  // removes the entry with a key of 1 from the map
System.print(fruit)              // prints the rest of the map
System.print()
var capitals = {                 // creates a new map with three entries
    "France": "Paris",
    "Germany": "Berlin",
    "Spain": "Madrid"
}
capitals["Russia"] = "Moscow"    // adds another entry
System.print(capitals["France"]) // retrieves the "France" entry and prints out its capital
capitals.remove("France")        // removes the "France" entry
System.print(capitals)           // prints all remaining entries
System.print(capitals.count)     // prints the number of remaining entries
System.print(capitals["Sweden"]) // prints the entry for Sweden (null as there isn't one)
