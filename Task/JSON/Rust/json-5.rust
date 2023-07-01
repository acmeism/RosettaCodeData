use std::collections::HashMap;
use serde_json::Value;

#[derive(Serialize, Deserialize)]
struct Data {
    points: Vec<Points>,

    #[serde(flatten)]
    metadata: HashMap<String, Value>,
}
