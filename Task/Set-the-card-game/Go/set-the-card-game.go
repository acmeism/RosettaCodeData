package main

import (
	"fmt"
	"math/rand"
	"strings"
	"time"
)

type Feature interface{}

type Number int
const (
	ONE Number = iota
	TWO
	THREE
)

func (n Number) String() string {
	return [...]string{"ONE", "TWO", "THREE"}[n]
}

type Colour int
const (
	GREEN Colour = iota
	RED
	PURPLE
)

func (c Colour) String() string {
	return [...]string{"GREEN", "RED", "PURPLE"}[c]
}

type Shading int
const (
	OPEN Shading = iota
	SOLID
	STRIPED
)

func (s Shading) String() string {
	return [...]string{"OPEN", "SOLID", "STRIPED"}[s]
}

type Shape int
const (
	DIAMOND Shape = iota
	OVAL
	SQUIGGLE
)

func (s Shape) String() string {
	return [...]string{"DIAMOND", "OVAL", "SQUIGGLE"}[s]
}

type Card struct {
	number  Number
	colour  Colour
	shading Shading
	shape   Shape
}

func (c Card) String() string {
	return fmt.Sprintf("[%s %s %s %s]", c.number, c.colour, c.shading, c.shape)
}

func createPackOfCards() []Card {
	pack := make([]Card, 0, 81)
	for _, number := range []Number{ONE, TWO, THREE} {
		for _, colour := range []Colour{GREEN, RED, PURPLE} {
			for _, shading := range []Shading{OPEN, SOLID, STRIPED} {
				for _, shape := range []Shape{DIAMOND, OVAL, SQUIGGLE} {
					pack = append(pack, Card{number, colour, shading, shape})
				}
			}
		}
	}
	return pack
}

func isGameSet(triple []Card) bool {
	numbers := make([]Feature, len(triple))
	colours := make([]Feature, len(triple))
	shadings := make([]Feature, len(triple))
	shapes := make([]Feature, len(triple))
	
	for i, card := range triple {
		numbers[i] = card.number
		colours[i] = card.colour
		shadings[i] = card.shading
		shapes[i] = card.shape
	}
	
	return allSameOrAllDifferent(numbers) &&
		   allSameOrAllDifferent(colours) &&
		   allSameOrAllDifferent(shadings) &&
		   allSameOrAllDifferent(shapes)
}

func allSameOrAllDifferent(features []Feature) bool {
	featureSet := make(map[Feature]bool)
	for _, feature := range features {
		featureSet[feature] = true
	}
	return len(featureSet) == 1 || len(featureSet) == 3
}

func combinations(list []Card, choose int) [][]Card {
	combinations := make([][]Card, 0)
	combination := make([]int, choose)
	
	// Initialize with first combination
	for i := 0; i < choose; i++ {
		combination[i] = i
	}
	
	for combination[choose-1] < len(list) {
		// Create current combination
		current := make([]Card, choose)
		for i, idx := range combination {
			current[i] = list[idx]
		}
		combinations = append(combinations, current)
		
		// Generate next combination
		temp := choose - 1
		for temp != 0 && combination[temp] == len(list) - choose + temp {
			temp -= 1
		}
		combination[temp]++
		for i := temp + 1; i < choose; i++ {
			combination[i] = combination[i-1] + 1
		}
	}
	
	return combinations
}

func shuffleCards(cards []Card) {
	rand.Shuffle(len(cards), func(i, j int) {
		cards[i], cards[j] = cards[j], cards[i]
	})
}

func main() {
	rand.Seed(time.Now().UnixNano())
	
	pack := createPackOfCards()
	for _, cardCount := range []int{4, 8, 12} {
		shuffleCards(pack)
		deal := make([]Card, cardCount)
		copy(deal, pack[:cardCount])
		
		fmt.Printf("Cards dealt: %d\n", cardCount)
		for _, card := range deal {
			fmt.Println(card)
		}
		fmt.Println()
		
		fmt.Println("Sets found: ")
		for _, combo := range combinations(deal, 3) {
			if isGameSet(combo) {
				cardStrings := make([]string, len(combo))
				for i, card := range combo {
					cardStrings[i] = card.String()
				}
				fmt.Println(strings.Join(cardStrings, " "))
			}
		}
		fmt.Println("-------------------------\n")
	}
}
