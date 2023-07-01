suits := ["♠", "♦", "♥", "♣"]
values := [2,3,4,5,6,7,8,9,10,"J","Q","K","A"]
Gui, font, s14
Gui, add, button, w190 gNewDeck, New Deck
Gui, add, button, x+10 wp gShuffle, Shuffle
Gui, add, button, x+10 wp gDeal, Deal
Gui, add, text, xs w600 , Current Deck:
Gui, add, Edit, xs wp r4 vDeck
Gui, add, text, xs , Hands:
Gui, add, Edit, x+10 w60  vHands gHands
Gui, add, UpDown,, 1
Edits := 0

Hands:
Gui, Submit, NoHide
loop, % Edits
	GuiControl,Hide, Hand%A_Index%

loop, % Hands
	GuiControl,Show, % "Hand" A_Index

loop, % Hands - Edits
{
	Edits++
	Gui, add, ListBox, % "x" (Edits=1?"s":"+10") " w60 r13 vHand" Edits
}
Gui, show, AutoSize
return
;-----------------------------------------------
GuiClose:
ExitApp
return
;-----------------------------------------------
NewDeck:
cards := [], deck := Dealt:= ""

loop, % Hands
	GuiControl,, Hand%A_Index%, |

for each, suit in suits
	for each, value in values
		cards.Insert(value suit)

for each, card in cards
	deck .= card (mod(A_Index, 13) ? " " : "`n")
GuiControl,, Deck, % deck
GuiControl,, Dealt
GuiControl, Enable, Button2
GuiControl, Enable, Hands
return
;-----------------------------------------------
shuffle:
gosub, NewDeck
shuffled := [], deck := ""
loop, 52 {
	Random, rnd, 1, % cards.MaxIndex()
	shuffled[A_Index] := cards.RemoveAt(rnd)
}
for each, card in shuffled
{
	deck .= card (mod(A_Index, 13) ? " " : "`n")	
	cards.Insert(card)
}
GuiControl,, Deck, % deck
return
;-----------------------------------------------
Deal:
Gui, Submit, NoHide
if ( Hands > cards.MaxIndex())
	return

deck := ""
loop, % Hands
	GuiControl,, Hand%A_Index%, % cards.RemoveAt(1)

GuiControl, Disable, Button2
GuiControl, Disable, Hands
GuiControl,, Dealt, % Dealt

for each, card in cards
	deck .= card (mod(A_Index, 13) ? " " : "`n")
GuiControl,, Deck, % deck
return
;-----------------------------------------------
