package main

import (
	"encoding/xml"
	"fmt"
	"log"
	"os"
)

type Inventory struct {
	XMLName  xml.Name `xml:"inventory"`
	Title    string   `xml:"title,attr"`
	Sections []struct {
		XMLName xml.Name `xml:"section"`
		Name    string   `xml:"name,attr"`
		Items   []struct {
			XMLName     xml.Name `xml:"item"`
			Name        string   `xml:"name"`
			UPC         string   `xml:"upc,attr"`
			Stock       int      `xml:"stock,attr"`
			Price       float64  `xml:"price"`
			Description string   `xml:"description"`
		} `xml:"item"`
	} `xml:"section"`
}

// To simplify main's error handling
func printXML(s string, v interface{}) {
	fmt.Println(s)
	b, err := xml.MarshalIndent(v, "", "\t")
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(string(b))
	fmt.Println()
}

func main() {
	fmt.Println("Reading XML from standard input...")

	var inv Inventory
	dec := xml.NewDecoder(os.Stdin)
	if err := dec.Decode(&inv); err != nil {
		log.Fatal(err)
	}

	// At this point, inv is Go struct with all the fields filled
	// in from the XML data. Well-formed XML input that doesn't
	// match the specification of the fields in the Go struct are
	// discarded without error.

	// We can reformat the parts we parsed:
	//printXML("Got:", inv)

	// 1. Retrieve first item:
	item := inv.Sections[0].Items[0]
	fmt.Println("item variable:", item)
	printXML("As XML:", item)

	// 2. Action on each price:
	fmt.Println("Prices:")
	var totalValue float64
	for _, s := range inv.Sections {
		for _, i := range s.Items {
			fmt.Println(i.Price)
			totalValue += i.Price * float64(i.Stock)
		}
	}
	fmt.Println("Total inventory value:", totalValue)
	fmt.Println()

	// 3. Slice of all the names:
	var names []string
	for _, s := range inv.Sections {
		for _, i := range s.Items {
			names = append(names, i.Name)
		}
	}
	fmt.Printf("names: %q\n", names)
}
