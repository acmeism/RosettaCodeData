package main

import (
    "encoding/xml"
    "fmt"
)

// Function required by task description.
func xRemarks(r CharacterRemarks) (string, error) {
    b, err := xml.MarshalIndent(r, "", "    ")
    return string(b), err
}

// Task description allows the function to take "a single mapping..."
// This data structure represents a mapping.
type CharacterRemarks struct {
    Character []crm
}

type crm struct {
    Name   string `xml:"name,attr"`
    Remark string `xml:",chardata"`
}

func main() {
    x, err := xRemarks(CharacterRemarks{[]crm{
        {`April`, `Bubbly: I'm > Tam and <= Emily`},
        {`Tam O'Shanter`, `Burns: "When chapman billies leave the street ..."`},
        {`Emily`, `Short & shrift`},
    }})
    if err != nil {
        x = err.Error()
    }
    fmt.Println(x)
}
