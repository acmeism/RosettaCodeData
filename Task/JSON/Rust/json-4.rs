#[derive(Serialize, Deserialize)]
struct W { a: i32, b: i32 }  // => { "a": 0, "b": 0 }

#[derive(Serialize, Deserialize)]
struct X(i32, i32);          // => [0, 0]

#[derive(Serialize, Deserialize)]
struct Y(i32);               // => 0

#[derive(Serialize, Deserialize)]
struct Z;                    // => null

#[derive(Serialize, Deserialize)]
enum E {
    W { a: i32, b: i32 },    // => { "W": { "a": 0, "b": 0 } }
    X(i32, i32),             // => { "X": [0, 0] }
    Y(i32),                  // => { "Y": 0 }
    Z,                       // => { "Z" }
}
