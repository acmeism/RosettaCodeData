package main

import (
	"os"
	"fmt"
	"config"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Printf("Usage: %v <configfile>\n", os.Args[0])
		os.Exit(1)
	}

	file, err := os.Open(os.Args[1])
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	defer file.Close()

	conf, err := config.Parse(file)
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fullname, err := conf.String("fullname")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	favouritefruit, err := conf.String("favouritefruit")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	needspeeling, err := conf.Bool("needspeeling")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	seedsremoved, err := conf.Bool("seedsremoved")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	otherfamily, err := conf.Array("otherfamily")
	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}

	fmt.Printf("FULLNAME: %q\n", fullname)
	fmt.Printf("FAVOURITEFRUIT: %q\n", favouritefruit)
	fmt.Printf("NEEDSPEELING: %q\n", needspeeling)
	fmt.Printf("SEEDSREMOVED: %q\n", seedsremoved)
	fmt.Printf("OTHERFAMILY: %q\n", otherfamily)
}
