import "std/json.zc"

fn main() {
    // Load a JSON string into a data structure
    // Double braces {{ }} are used to escape Zen C's string interpolation
    let input = "{{\"user\": \"zuhaitz\", \"version\": 4.2, \"active\": true}}";
    let json = JsonValue::parse_val(input).expect("failed to parse json");

    let user = json.get_string("user").unwrap();
    let active = json.get_bool("active").unwrap();
    println "Loaded User: {user} (Active: {active})";

    // Create a new data structure and serialize it into JSON
    let res = JsonValue::object();
    res.set("status", JsonValue::string("ok"));
    res.set("timestamp", JsonValue::number(1710422672));

    let tags = JsonValue::array();
    tags.push(JsonValue::string("zen-c"));
    tags.push(JsonValue::string("fast"));
    res.set("tags", tags);

    println "Serialized: {res.to_string().c_str()}";
}
