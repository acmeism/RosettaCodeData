package main

import (
    "./romap"
    "fmt"
)

func main() {
    // create a normal map
    m := map[byte]int{'A': 65, 'B': 66, 'C': 67}

    // place it in a read-only wrapper so no new item can be added or item deleted.
    rom := romap.New(m)

    // retrieve value represented by 'C' say
    i, _ := rom.Get('C')
    fmt.Println("'C' maps to", i)

    // reset this to default value (doesn't actually delete the key)
    rom.Reset('C')
    i, _ = rom.Get('C')
    fmt.Println("'C' now maps to", i)
}
