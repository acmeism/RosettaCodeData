package main

import (
	"errors"
	"flag"
	"fmt"
	"log"
	"math/rand"
	"strings"
	"time"
)

func main() {
	log.SetPrefix("mastermind: ")
	log.SetFlags(0)
	colours := flag.Int("colours", 6, "number of colours to use (2-20)")
	flag.IntVar(colours, "colors", 6, "alias for colours")
	holes := flag.Int("holes", 4, "number of holes (the code length, 4-10)")
	guesses := flag.Int("guesses", 12, "number of guesses allowed (7-20)")
	unique := flag.Bool("unique", false, "disallow duplicate colours in the code")
	flag.Parse()

	rand.Seed(time.Now().UnixNano())
	m, err := NewMastermind(*colours, *holes, *guesses, *unique)
	if err != nil {
		log.Fatal(err)
	}
	err = m.Play()
	if err != nil {
		log.Fatal(err)
	}
}

type mastermind struct {
	colours int
	holes   int
	guesses int
	unique  bool

	code   string
	past   []string // history of guesses
	scores []string // history of scores
}

func NewMastermind(colours, holes, guesses int, unique bool) (*mastermind, error) {
	if colours < 2 || colours > 20 {
		return nil, errors.New("colours must be between 2 and 20 inclusive")
	}
	if holes < 4 || holes > 10 {
		return nil, errors.New("holes must be between 4 and 10 inclusive")
	}
	if guesses < 7 || guesses > 20 {
		return nil, errors.New("guesses must be between 7 and 20 inclusive")
	}
	if unique && holes > colours {
		return nil, errors.New("holes must be > colours when using unique")
	}

	return &mastermind{
		colours: colours,
		holes:   holes,
		guesses: guesses,
		unique:  unique,
		past:    make([]string, 0, guesses),
		scores:  make([]string, 0, guesses),
	}, nil
}

func (m *mastermind) Play() error {
	m.generateCode()
	fmt.Printf("A set of %s has been selected as the code.\n", m.describeCode(m.unique))
	fmt.Printf("You have %d guesses.\n", m.guesses)
	for len(m.past) < m.guesses {
		guess, err := m.inputGuess()
		if err != nil {
			return err
		}
		fmt.Println()
		m.past = append(m.past, guess)
		str, won := m.scoreString(m.score(guess))
		if won {
			plural := "es"
			if len(m.past) == 1 {
				plural = ""
			}
			fmt.Printf("You found the code in %d guess%s.\n", len(m.past), plural)
			return nil
		}
		m.scores = append(m.scores, str)
		m.printHistory()
		fmt.Println()
	}
	fmt.Printf("You are out of guesses. The code was %s.\n", m.code)
	return nil
}

const charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
const blacks = "XXXXXXXXXX"
const whites = "OOOOOOOOOO"
const nones = "----------"

func (m *mastermind) describeCode(unique bool) string {
	ustr := ""
	if unique {
		ustr = " unique"
	}
	return fmt.Sprintf("%d%s letters (from 'A' to %q)",
		m.holes, ustr, charset[m.colours-1],
	)
}

func (m *mastermind) printHistory() {
	for i, g := range m.past {
		fmt.Printf("-----%s---%[1]s--\n", nones[:m.holes])
		fmt.Printf("%2d:  %s : %s\n", i+1, g, m.scores[i])
	}
}

func (m *mastermind) generateCode() {
	code := make([]byte, m.holes)
	if m.unique {
		p := rand.Perm(m.colours)
		for i := range code {
			code[i] = charset[p[i]]
		}
	} else {
		for i := range code {
			code[i] = charset[rand.Intn(m.colours)]
		}
	}
	m.code = string(code)
	//log.Printf("code is %q", m.code)
}

func (m *mastermind) inputGuess() (string, error) {
	var input string
	for {
		fmt.Printf("Enter guess #%d: ", len(m.past)+1)
		if _, err := fmt.Scanln(&input); err != nil {
			return "", err
		}
		input = strings.ToUpper(strings.TrimSpace(input))
		if m.validGuess(input) {
			return input, nil
		}
		fmt.Printf("A guess must consist of %s.\n", m.describeCode(false))
	}
}

func (m *mastermind) validGuess(input string) bool {
	if len(input) != m.holes {
		return false
	}
	for i := 0; i < len(input); i++ {
		c := input[i]
		if c < 'A' || c > charset[m.colours-1] {
			return false
		}
	}
	return true
}

func (m *mastermind) score(guess string) (black, white int) {
	scored := make([]bool, m.holes)
	for i := 0; i < len(guess); i++ {
		if guess[i] == m.code[i] {
			black++
			scored[i] = true
		}
	}
	for i := 0; i < len(guess); i++ {
		if guess[i] == m.code[i] {
			continue
		}
		for j := 0; j < len(m.code); j++ {
			if i != j && !scored[j] && guess[i] == m.code[j] {
				white++
				scored[j] = true
			}
		}
	}
	return
}

func (m *mastermind) scoreString(black, white int) (string, bool) {
	none := m.holes - black - white
	return blacks[:black] + whites[:white] + nones[:none], black == m.holes
}
