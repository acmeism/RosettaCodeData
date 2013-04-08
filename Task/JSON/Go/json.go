package main

import "encoding/json"
import "fmt"

func main() {
    var data interface{}
    err := json.Unmarshal([]byte(`{"foo":1, "bar":[10, "apples"]}`), &data)
    if err == nil {
        fmt.Println(data)
    } else {
        fmt.Println(err)
    }

    sample := map[string]interface{}{
        "blue":  []interface{}{1, 2},
        "ocean": "water",
    }
    json_string, err := json.Marshal(sample)
    if err == nil {
        fmt.Println(string(json_string))
    } else {
        fmt.Println(err)
    }
}
