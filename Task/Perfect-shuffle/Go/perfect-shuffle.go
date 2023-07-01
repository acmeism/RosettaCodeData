package main

import "fmt"

type Deck struct {
	Cards []int
	length int
}

func NewDeck(deckSize int) (res *Deck){
	if deckSize % 2 != 0{
		panic("Deck size must be even")
	}
	res = new(Deck)
	res.Cards = make([]int, deckSize)
	res.length = deckSize
	for i,_ := range  res.Cards{
		res.Cards[i] = i
	}
	return
}
func (d *Deck)shuffleDeck(){
	tmp := make([]int,d.length)
	for i := 0;i <d.length/2;i++  {
		tmp[i*2] = d.Cards[i]
		tmp[i*2+1] = d.Cards[d.length / 2 + i]
	}
	d.Cards = tmp
}
func (d *Deck) isEqualTo(c Deck) (res bool) {
	if d.length != c.length {
		panic("Decks aren't equally sized")
	}
	res = true
	for i, v := range d.Cards{
		if v != c.Cards[i] {
			res = false
		}
	}
	return
}


func main(){
	for _,v := range []int{8,24,52,100,1020,1024,10000} {
		fmt.Printf("Cards count: %d, shuffles required: %d\n",v,ShufflesRequired(v))
	}
}

func ShufflesRequired(deckSize int)(res int){
	deck := NewDeck(deckSize)
	Ref := *deck
	deck.shuffleDeck()
	res++
	for ;!deck.isEqualTo(Ref);deck.shuffleDeck(){
		res++
	}
	return
}
