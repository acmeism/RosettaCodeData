fn main() {
    let point = Point { x: 1, y: 2 };

    let serialized = serde_json::to_string(&point).unwrap();
    let deserialized: Point = serde_json::from_str(&serialized).unwrap();

    println!("serialized = {}", serialized);
    println!("deserialized = {:?}", deserialized);
}
