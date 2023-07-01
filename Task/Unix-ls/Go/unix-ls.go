package main

import (
	"fmt"
	"log"
	"os"
	"sort"
)

func main() {
	f, err := os.Open(".")
	if err != nil {
		log.Fatal(err)
	}
	files, err := f.Readdirnames(0)
	f.Close()
	if err != nil {
		log.Fatal(err)
	}
	sort.Strings(files)
	for _, n := range files {
		fmt.Println(n)
	}
}
