import "std/map.zc"

fn main() {
    // Create a new map with four entries.
    let capitals = Map<string>::new();
    capitals.put("France","Paris");
    capitals.put("Germany", "Berlin");
    capitals.put("Spain", "Madrid");
    capitals.put("Russia", "Moscow");

    // Iterate through the map and print out the key/value pairs.
    for entry in capitals {
        println "{{{entry.key}: {entry.val}}}";
    }
    println "";

    // Iterate through the map's slots and, if they're occupied, print out the keys.
    for i in 0..capitals.capacity() {
        if capitals.is_slot_occupied(i) { println "{capitals.key_at(i)}"; }
    }
    println "";

    // Iterate through the map's slots and, if they're occupied, print out the values.
    for i in 0..capitals.capacity() {
        if capitals.is_slot_occupied(i) { println "{capitals.val_at(i)}"; }
    }
}
