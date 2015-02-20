package main

import (
    "log"
    "os"

    "github.com/BurntSushi/toml"
)

type Node struct {
    Name     string
    Children []*Node
}

func main() {
    tree := &Node{"root", []*Node{
        &Node{"a", []*Node{
            &Node{"d", nil},
            &Node{"e", []*Node{
                &Node{"f", nil},
            }}}},
        &Node{"b", nil},
        &Node{"c", nil},
    }}
    enc := toml.NewEncoder(os.Stdout)
    enc.Indent = "   "
    err := enc.Encode(tree)
    if err != nil {
        log.Fatal(err)
    }
}
