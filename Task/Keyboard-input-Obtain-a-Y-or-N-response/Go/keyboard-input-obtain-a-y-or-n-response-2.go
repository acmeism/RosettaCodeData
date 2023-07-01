package main
// siongui.github.io/2016/04/23/go-read-yes-no-from-console
import (
	"fmt"
	"strings"
)

func ask() bool {
	var s string
	fmt.Printf("(y/n): ")
	fmt.Scan(&s)
	s = strings.TrimSpace(s)
	s = strings.ToLower(s)
	if s == "y" || s == "yes" {
		return true
	}
	return false
}

func main() {
	ans := ask()
	if ans {
		fmt.Println("yes")
	} else {
		fmt.Println("no")
	}
}
