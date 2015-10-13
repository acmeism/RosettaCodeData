package main

import (
	"fmt"
	"log"
	"net/url"
)

func main() {
	for _, escaped := range []string{
		"http%3A%2F%2Ffoo%20bar%2F",
		"google.com/search?q=%60Abdu%27l-Bah%C3%A1",
	} {
		u, err := url.QueryUnescape(escaped)
		if err != nil {
			log.Println(err)
			continue
		}
		fmt.Println(u)
	}
}
