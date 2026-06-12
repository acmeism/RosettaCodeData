package main

import (
	"fmt"
	"strings"
)

func process(axiom string, steps int, rules map[string][]string) {
	res := make([]string, 0)
	res = append(res, axiom)

	for range steps {
		fmt.Println(strings.Join(res, ""))

		tmp := make([]string, 0)

		for _, axiom := range res {
			tmp = append(tmp, rules[axiom]...)
		}

		res = tmp
	}
}

func main() {
	rules := map[string][]string{
		"I": {"M"},
		"M": {"M", "I"},
	}
	process("I", 5, rules)
}
