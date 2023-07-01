BullCow	New bull,cow,guess,guessed,ii,number,pos,x
	Set number="",x=1234567890
	For ii=1:1:4 Do
	. Set pos=$Random($Length(x))+1
	. Set number=number_$Extract(x,pos)
	. Set $Extract(x,pos)=""
	. Quit
	Write !,"The computer has selected a number that consists"
	Write !,"of four different digits."
	Write !!,"As you are guessing the number, ""bulls"" and ""cows"""
	Write !,"will be awarded: a ""bull"" for each digit that is"
	Write !,"placed in the correct position, and a ""cow"" for each"
	Write !,"digit that occurs in the number, but in a different place.",!
	Write !,"For a guess, enter 4 digits."
	Write !,"Any other input is interpreted as ""I give up"".",!
	Set guessed=0 For  Do  Quit:guessed
	. Write !,"Your guess: " Read guess If guess'?4n Set guessed=-1 Quit
	. Set (bull,cow)=0,x=guess
	. For ii=4:-1:1 If $Extract(x,ii)=$Extract(number,ii) Do
	. . Set bull=bull+1,$Extract(x,ii)=""
	. . Quit
	. For ii=1:1:$Length(x) Set:number[$Extract(x,ii) cow=cow+1
	. Write !,"You guessed ",guess,". That earns you "
	. If 'bull,'cow Write "neither bulls nor cows..." Quit
	. If bull Write bull," bull" Write:bull>1 "s"
	. If cow Write:bull " and " Write cow," cow" Write:cow>1 "s"
	. Write "."
	. If bull=4 Set guessed=1 Write !,"That's a perfect score."
	. Quit
	If guessed<0 Write !!,"The number was ",number,".",!
	Quit
Do BullCow

The computer has selected a number that consists
of four different digits.

As you are guessing the number, "bulls" and "cows"
will be awarded: a "bull" for each digit that is
placed in the correct position, and a "cow" for each
digit that occurs in the number, but in a different place.

For a guess, enter 4 digits.
Any other input is interpreted as "I give up".

Your guess: 1234
You guessed 1234. That earns you 1 cow.
Your guess: 5678
You guessed 5678. That earns you 1 cow.
Your guess: 9815
You guessed 9815. That earns you 1 cow.
Your guess: 9824
You guessed 9824. That earns you 2 cows.
Your guess: 9037
You guessed 9037. That earns you 1 bull and 2 cows.
Your guess: 9048
You guessed 2789. That earns you 1 bull and 2 cows.
Your guess: 2079
You guessed 2079. That earns you 1 bull and 3 cows.
Your guess: 2709
You guessed 2709. That earns you 2 bulls and 2 cows.
Your guess: 0729
You guessed 0729. That earns you 4 cows.
Your guess: 2907
You guessed 2907. That earns you 4 bulls.
That's a perfect score.
