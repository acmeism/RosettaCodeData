package main

import "encoding/json"
import "fmt"

type Person struct {
    Name string   `json:"name"`
    Age  int      `json:"age,omitempty"`
    Addr *Address `json:"address,omitempty"`
    Ph   []string `json:"phone,omitempty"`
}

type Address struct {
    Street string `json:"street"`
    City   string `json:"city"`
    State  string `json:"state"`
    Zip    string `json:"zip"`
}

func main() {
    // compare with output, note apt field ignored, missing fields
    // have zero values.
    jData := []byte(`{
        "name": "Smith",
        "address": {
            "street": "21 2nd Street",
            "apt": "507",
            "city": "New York",
            "state": "NY",
            "zip": "10021"
        }
    }`)
    var p Person
    err := json.Unmarshal(jData, &p)
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Printf("%+v\n  %+v\n\n", p, p.Addr)
    }

    // compare with output, note empty fields omitted.
    pList := []Person{
        {
            Name: "Jones",
            Age:  21,
        },
        {
            Name: "Smith",
            Addr: &Address{"21 2nd Street", "New York", "NY", "10021"},
            Ph:   []string{"212 555-1234", "646 555-4567"},
        },
    }
    jData, err = json.MarshalIndent(pList, "", "    ")
    if err != nil {
        fmt.Println(err)
    } else {
        fmt.Println(string(jData))
    }
}
