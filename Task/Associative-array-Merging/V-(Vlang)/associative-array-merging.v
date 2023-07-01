type Generic = int|string|f64
type Assoc = map[string]Generic

fn merge(base Assoc, update Assoc) Assoc {
    mut result := Assoc(map[string]Generic{})
    for k, v in base {
        result[k] = v
    }
    for k, v in update {
        result[k] = v
    }
    return result
}

fn main() {
    base := Assoc({"name": Generic("Rocket Skates"), "price": 12.75, "color": "yellow"})
    update := Assoc({"price": Generic(15.25), "color": "red", "year": 1974})
    result := merge(base, update)
    for k,v in result {
        println('$k: $v')
    }
}
