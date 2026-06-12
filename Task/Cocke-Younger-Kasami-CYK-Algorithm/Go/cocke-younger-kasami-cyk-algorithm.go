package main

import (
	"fmt"
	"strings"
)

// CYKParser implements the CYK parsing algorithm
type CYKParser struct {
	nonTerminals []string
	terminals    []string
	rules        map[string][][]string
}

// NewCYKParser creates a new CYK parser with the grammar rules
func NewCYKParser() *CYKParser {
	return &CYKParser{
		nonTerminals: []string{"NP", "Nom", "Det", "AP", "Adv", "A"},
		terminals:    []string{"book", "orange", "man", "tall", "heavy", "very", "muscular"},
		rules: map[string][][]string{
			"NP":  {{"Det", "Nom"}},
			"Nom": {{"AP", "Nom"}, {"book"}, {"orange"}, {"man"}},
			"AP":  {{"Adv", "A"}, {"heavy"}, {"orange"}, {"tall"}},
			"Det": {{"a"}},
			"Adv": {{"very"}, {"extremely"}},
			"A":   {{"heavy"}, {"orange"}, {"tall"}, {"muscular"}},
		},
	}
}

// Parse performs the CYK Algorithm
func (p *CYKParser) Parse(w []string) {
	n := len(w)

	// Initialize the table with empty sets
	T := make([][]map[string]bool, n)
	for i := 0; i < n; i++ {
		T[i] = make([]map[string]bool, n)
		for j := 0; j < n; j++ {
			T[i][j] = make(map[string]bool)
		}
	}

	// Filling in the table
	for j := 0; j < n; j++ {
		// Iterate over the rules
		for lhs, rules := range p.rules {
			for _, rhs := range rules {
				// If a terminal is found
				if len(rhs) == 1 && rhs[0] == w[j] {
					T[j][j][lhs] = true
				}
			}
		}

		for i := j; i >= 0; i-- {
			// Iterate over the range i to j
			for k := i; k < j; k++ {
				// Iterate over the rules
				for lhs, rules := range p.rules {
					for _, rhs := range rules {
						// If a non-terminal pair is found
						if len(rhs) == 2 &&
							T[i][k][rhs[0]] &&
							T[k+1][j][rhs[1]] {
							T[i][j][lhs] = true
						}
					}
				}
			}
		}
	}

	// If word can be formed by rules of given grammar
    if _, ok := T[0][n-1]["NP"]; ok {
		fmt.Println("True")
	} else {
		fmt.Println("False")
	}
}

func main() {
	// Given string
	w := strings.Split("a very heavy orange book", " ")

	// Create parser and parse
	parser := NewCYKParser()
	parser.Parse(w)
}
