fn main() {
    let data = {
        let mut metadata = HashMap::new();
        metadata.insert("triangle".to_string(), Value::Number(3.into()));
        metadata.insert("square".to_string(), Value::Bool(false));

        Data {
            points: vec![Point { x: 1, y: 2 }, Point { x: 15, y: 32 }],
            metadata,
        }
    };

    let serialized = serde_json::to_string(&data).unwrap();
    let deserialized: Data = serde_json::from_str(&serialized).unwrap();

    println!("serialized = {}", serialized);
    println!("deserialized = {:?}", deserialized);
}
