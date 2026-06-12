package main

import (
	"fmt"
)

// Define the State structure
type State struct {
	label rune    // Character label, 0 for epsilon
	edge1 *State  // First transition
	edge2 *State  // Second transition
}

// Define the NFA structure
type NFA struct {
	initial *State
	accept  *State
}

// Function to convert infix regex to postfix using the Shunting Yard algorithm
func shunt(infix string) string {
	specials := map[rune]int{
		'*': 60,
		'+': 55,
		'?': 50,
		'.': 40,
		'|': 20,
	}

	var postfix []rune
	var stack []rune

	for _, c := range infix {
		if c == '(' {
			stack = append(stack, c)
		} else if c == ')' {
			for len(stack) > 0 && stack[len(stack)-1] != '(' {
				postfix = append(postfix, stack[len(stack)-1])
				stack = stack[:len(stack)-1]
			}
			if len(stack) > 0 {
				stack = stack[:len(stack)-1] // Remove '('
			}
		} else if _, ok := specials[c]; ok {
			for len(stack) > 0 {
				top := stack[len(stack)-1]
				if _, ok := specials[top]; ok && specials[c] <= specials[top] {
					postfix = append(postfix, top)
					stack = stack[:len(stack)-1]
				} else {
					break
				}
			}
			stack = append(stack, c)
		} else {
			postfix = append(postfix, c)
		}
	}

	for len(stack) > 0 {
		postfix = append(postfix, stack[len(stack)-1])
		stack = stack[:len(stack)-1]
	}

	return string(postfix)
}

// Function to compute the epsilon closure of a state
func followes(state *State) map[*State]bool {
	states := make(map[*State]bool)
	stack := []*State{state}

	for len(stack) > 0 {
		s := stack[len(stack)-1]
		stack = stack[:len(stack)-1]
		if !states[s] {
			states[s] = true
			if s.label == 0 { // Epsilon transition
				if s.edge1 != nil {
					stack = append(stack, s.edge1)
				}
				if s.edge2 != nil {
					stack = append(stack, s.edge2)
				}
			}
		}
	}

	return states
}

// Function to compile postfix regex into an NFA
func compileRegex(postfix string) NFA {
	var nfaStack []NFA

	for _, c := range postfix {
		switch c {
		case '*':
			nfa1 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			initial := &State{}
			accept := &State{}
			initial.edge1 = nfa1.initial
			initial.edge2 = accept
			nfa1.accept.edge1 = nfa1.initial
			nfa1.accept.edge2 = accept
			nfaStack = append(nfaStack, NFA{initial, accept})
		case '+':
			nfa1 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			initial := &State{}
			accept := &State{}
			initial.edge1 = nfa1.initial
			nfa1.accept.edge1 = nfa1.initial
			nfa1.accept.edge2 = accept
			nfaStack = append(nfaStack, NFA{initial, accept})
		case '?':
			nfa1 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			initial := &State{}
			accept := &State{}
			initial.edge1 = nfa1.initial
			initial.edge2 = accept
			nfa1.accept.edge1 = accept
			nfaStack = append(nfaStack, NFA{initial, accept})
		case '.':
			nfa2 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			nfa1 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			nfa1.accept.edge1 = nfa2.initial
			nfaStack = append(nfaStack, NFA{nfa1.initial, nfa2.accept})
		case '|':
			nfa2 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			nfa1 := nfaStack[len(nfaStack)-1]
			nfaStack = nfaStack[:len(nfaStack)-1]
			initial := &State{}
			accept := &State{}
			initial.edge1 = nfa1.initial
			initial.edge2 = nfa2.initial
			nfa1.accept.edge1 = accept
			nfa2.accept.edge1 = accept
			nfaStack = append(nfaStack, NFA{initial, accept})
		default: // Literal character
			initial := &State{label: c}
			accept := &State{}
			initial.edge1 = accept
			nfaStack = append(nfaStack, NFA{initial, accept})
		}
	}

	return nfaStack[len(nfaStack)-1]
}

// Function to match a string against the regex
func matchRegex(infix, str string) bool {
	postfix := shunt(infix)
	// Uncomment the next line to see the postfix expression
	// fmt.Println("Postfix:", postfix)

	nfa := compileRegex(postfix)

	currentStates := followes(nfa.initial)
	var nextStates map[*State]bool

	for _, c := range str {
		nextStates = make(map[*State]bool)
		for state := range currentStates {
			if state.label == c {
				follow := followes(state.edge1)
				for s := range follow {
					nextStates[s] = true
				}
			}
		}
		currentStates = nextStates
	}

	return currentStates[nfa.accept]
}

func main() {
	infixes := []string{"a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"}
	strings := []string{"", "abc", "abbc", "abcc", "abad", "abbbc"}

	for _, infix := range infixes {
		for _, str := range strings {
			result := matchRegex(infix, str)
			if result {
				fmt.Println("True", infix, str)
			} else {
				fmt.Println("False", infix, str)
			}
		}
		fmt.Println()
	}
}
