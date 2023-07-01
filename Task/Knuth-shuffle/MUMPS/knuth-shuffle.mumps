Shuffle(items,separator)	New ii,item,list,n
	Set list="",n=0
	Set ii="" For  Set ii=$Order(items(ii)) Quit:ii=""  Do
	. Set n=n+1,list(n)=items(ii),list=list_$Char(n)
	. Quit
	For  Quit:list=""  Do
	. Set n=$Random($Length(list))+1
	. Set item=list($ASCII(list,n))
	. Set $Extract(list,n)=""
	. Write item,separator
	. Quit
	Quit
CardDeck	New card,ii,suite
	Set ii=0
	For suite="Spades","Hearts","Clubs","Diamonds" Do
	. For card=2:1:10,"Jack","Queen","King","Ace" Do
	. . Set ii=ii+1,items(ii)=card_" of "_suite
	. . Quit
	. Quit
	Quit

Kill items
Set items(91)="Red"
Set items(82)="White"
Set items(73)="Blue"
Set items(64)="Yellow"
Set items(55)="Green"
Do Shuffle(.items,"  ") ; Red  Yellow  White  Green  Blue
Do Shuffle(.items,"  ") ; Red  Blue  Yellow  White  Green
Do Shuffle(.items,"  ") ; Green  Blue  Yellow  White  Red

Kill items Do CardDeck,Shuffle(.items,$Char(13,10))
Queen of Hearts
9 of Diamonds
10 of Hearts
King of Hearts
7 of Diamonds
9 of Clubs
6 of Diamonds
8 of Diamonds
Jack of Spades
Ace of Hearts
Queen of Diamonds
9 of Hearts
2 of Hearts
King of Clubs
10 of Spades
7 of Clubs
6 of Clubs
3 of Diamonds
3 of Spades
Queen of Clubs
Ace of Spades
4 of Hearts
Ace of Diamonds
7 of Spades
Ace of Clubs
King of Spades
10 of Diamonds
Jack of Diamonds
8 of Clubs
4 of Spades
Jack of Hearts
10 of Clubs
4 of Diamonds
3 of Hearts
2 of Diamonds
5 of Hearts
Jack of Clubs
2 of Clubs
5 of Diamonds
6 of Hearts
4 of Clubs
9 of Spades
3 of Clubs
5 of Spades
6 of Spades
7 of Hearts
8 of Spades
8 of Hearts
2 of Spades
Queen of Spades
King of Diamonds
5 of Clubs
