Deck:=new Deck
Deck.Shuffle()
msgbox % Deck.Show()
loop, 2
	msgbox % Deck.Deal().Show()
msgbox % Deck.Show()
Return ;-------------------------------------------------------------------

class Card
{
	__New(Pip, Suit) {
		this.Pip:=Pip, this.Suit:=Suit
	}
	Show() {
		Return this.Pip . this.Suit
	}
}

class Deck
{
	Suits:={1:"♣",2:"♦",3:"♠",4:"♥"}
	Pips:={13:"A",1:"2",2:"3",3:"4",4:"5",5:"6",6:"7",7:"8",8:"9",9:"T",10:"J",11:"Q",12:"K"}
	
	__New() {
		this.Deck:=[]
		For i, Pip in this.Pips
			For j, Suit in this.Suits
				this.Deck.Insert(new Card(Pip,Suit))
	}
	Shuffle() {	; Knuth Shuffle from http://rosettacode.org/wiki/Knuth_Shuffle#AutoHotkey
		Loop % this.Deck.MaxIndex()-1 {
			Random, i, A_Index, this.Deck.MaxIndex()	; swap item 1,2... with a random item to the right of it
			temp := this.Deck[i], this.Deck[i] := this.Deck[A_Index], this.Deck[A_Index] := temp
		}
	}
	Deal() {
		Return this.Deck.Remove() ; to deal from bottom, use Remove(1)
	}
	Show() {
		For i, Card in this.Deck
			s .= Card.Show() " "
		Return s
	}
}
