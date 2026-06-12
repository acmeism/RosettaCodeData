use serde_json::{ json, Value };

type JSONPointer = Vec<String>;

fn new_json_pointer(pstring: &str) -> Result<JSONPointer, String> {
    return jp_parse(pstring);
}

fn resolve(p: JSONPointer, data: Value) -> Result<Value, String> {
    return p.iter().fold(Ok(data), |accum, val| get_item(accum, val));
}

fn jp_parse(pst: &str) -> Result<Vec<String>, String> {
    if pst == "" {
        return Ok([].to_vec());
    }
    if pst.chars().nth(0).unwrap() != '/' {
        return Err(String::from("Non-empty JSON pointers must begin with /"));
    }
    return Ok(
        pst
            .split("/")
            .map(|s| String::from(s.replace("~1", "/").replace("~0", "~")))
            .collect::<Vec<String>>()[1..]
            .to_vec()
    );
}

fn get_item<'a>(obj: Result<Value, String>, token: &str) -> Result<Value, String> {
    match obj {
        Err(_) => {
            return obj; // propagate along
        }
        Ok(ob) => {
            match ob {
                Value::Array(arr) => {
                    let idx = usize::from_str_radix(token, 10);
                    match idx {
                        Err(..) => {
                            return Err(String::from("ParseIntErr"));
                        }
                        Ok(i) => {
                            if i < arr.len() {
                                return Ok(Value::String(arr[i].to_string()));
                            }
                            return Err(String::from(format!("Index {:?} out of range", token)));
                        }
                    }
                }
                Value::Object(dic) => {
                    if dic.contains_key(token) {
                        return Ok(dic[token].clone());
                    }
                    return Err(String::from(format!("Key error with {:?}", token)));
                }
                _ => {
                    return Err(String::from("Unknown object"));
                }
            }
        }
    }
}

fn main() {
    let doc =
        json!({
        "wiki" : {
            "links" : [
                "https://rosettacode.org/wiki/Rosetta_Code",
                "https://discord.com/channels/1011262808001880065",
            ],
        },
        "" : "Rosetta",
        " " : "Code",
        "g/h" : "chrestomathy",
        "i~j" : "site",
        "abc" : ["is", "a"],
        "def" : {"" : "programming"},
    });
    let examples = [
        "",
        "/",
        "/ ",
        "/abc",
        "/def/",
        "/g~1h",
        "/i~0j",
        "/wiki/links/0",
        "/wiki/links/1",
        "/wiki/links/2",
        "/wiki/name",
        "/no/such/thing",
        "bad/pointer",
    ];
    for p in examples {
        let jspointer = new_json_pointer(p);
        match jspointer {
            Err(error) => println!("JSON pointer creation error: {error}"),
            Ok(pointer) => {
                let result = resolve(pointer, doc.clone());
                match result {
                    Ok(val) => println!("\"{p}\" -> {val}"),
                    Err(err) => println!("Error: {p} does not exist: {err}"),
                }
            }
        }
    }
}
