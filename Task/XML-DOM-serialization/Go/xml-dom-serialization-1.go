package main

import (
    "fmt"
    dom "gitlab.com/stone.code/xmldom-go.git"
)

func main() {
    d, err := dom.ParseStringXml(`
<?xml version="1.0" ?>
<root>
    <element>
        Some text here
    </element>
</root>`)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(string(d.ToXml()))
}
