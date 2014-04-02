Loop, 52
{
   Random, card%A_Index%, 1, 52
   While card%A_Index%
      Random, card%A_Index%, 1, 52
   card%A_Index% := Mod(card%A_Index%, 12) . " of " . ((card%A_Index% <= 12)
      ? "diamonds" : ((card%A_Index%) <= 24)
      ? "hearts" : ((card%A_Index% <= 36)
      ? "clubs"
      : "spades"))
   allcards .= card%A_Index% . "`n"
}
currentcard = 1
Gui, Add, Text, vcard w500
Gui, Add, Button, w500 gNew, New Deck (Shuffle)
Gui, Add, Button, w500 gDeal, Deal Next Card
Gui, Add, Button, w500 gReveal, Reveal Entire Deck
Gui, Show,, Playing Cards
Return
New:
Reload
GuiClose:
ExitApp
Deal:
GuiControl,, card, % card%currentcard%
currentcard++
Return
Reveal:
GuiControl,, card, % allcards
Return
