package main

import (
	"fmt"
	"whatever/path/was/used/cards"
)

func main() {
	// We do not call rand.Seed() in order for the results to be repeatable.
	//rand.Seed(time.Now().UnixNano())
	d := cards.NewDeck()
	fmt.Println("fresh deck")
	fmt.Println(d)

	d.Shuffle()
	fmt.Println("\nshuffled")
	fmt.Println(d)

	h := d.Draw(5)
	fmt.Println("\n5 cards drawn")
	fmt.Println(h)

	fmt.Println("\nrank, suit values of cards in drawn:")
	fmt.Println("Card  Rank   Suit")
	for _, c := range h {
		fmt.Printf("%v :  %v=%2[2]d   %v=%2[3]d\n", c, c.Rank(), c.Suit())
	}

	ans := h.Contains(cards.NewCard(cards.Queen, cards.Spade))
	fmt.Println("Drawn cards include the Queen of Spades?", ans)
        ans = h.Contains(cards.NewCard(cards.Jack, cards.Spade))
        fmt.Println("Drawn cards include the Jack of Spades?", ans)

	p, _ := d.Deal(7, nil, nil)
	fmt.Println("\nDealing 7 cards to two players")
	fmt.Println("Player1:", p[0])
	fmt.Println("Player2:", p[1])

	fmt.Println("\n", len(d), " cards left in deck")
	fmt.Println(d)

	d.AddDeck(h, p[0], p[0])
	fmt.Println("\nReturning the cards to the deck")
	fmt.Println(d)
}
