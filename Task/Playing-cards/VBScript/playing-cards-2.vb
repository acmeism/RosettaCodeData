dim pack
set pack = new carddeck
wscript.echo "--before shuffle"
pack.showdeck
pack.shuffle
wscript.echo "--after shuffle"
pack.showdeck

dim card
for i = 1 to 52
	set card = pack.deal
next
wscript.echo "--dealt a card, it's the", card.pips, "of", card.suit
wscript.echo "--", pack.cardsRemaining, "cards remaining"
if pack.cardsRemaining <> 0 then
	pack.showdeck
end if
