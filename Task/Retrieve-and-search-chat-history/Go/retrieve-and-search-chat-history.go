package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

func get(url string) (res string, err error) {
	resp, err := http.Get(url)
	if err != nil {
		return "", err
	}
	buf, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return "", err
	}
	return string(buf), nil
}

func grep(needle string, haystack string) (res []string) {
	for _, line := range strings.Split(haystack, "\n") {
		if strings.Contains(line, needle) {
			res = append(res, line)
		}
	}
	return res
}

func genUrl(i int, loc *time.Location) string {
	date := time.Now().In(loc).AddDate(0, 0, i)
	return date.Format("http://tclers.tk/conferences/tcl/2006-01-02.tcl")
}

func main() {
	needle := os.Args[1]
	back := -10
	serverLoc, err := time.LoadLocation("Europe/Berlin")
	if err != nil {
		log.Fatal(err)
	}
	for i := back; i <= 0; i++ {
		url := genUrl(i, serverLoc)
		contents, err := get(url)
		if err != nil {
			log.Fatal(err)
		}
		found := grep(needle, contents)
		if len(found) > 0 {
			fmt.Printf("%v\n------\n", url)
			for _, line := range found {
				fmt.Printf("%v\n", line)
			}
			fmt.Printf("------\n\n")
		}
	}
}
