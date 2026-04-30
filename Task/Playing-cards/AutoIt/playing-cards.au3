#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>

; ## GLOBALS ##
Global $SUIT = ["D", "H", "S", "C"]
Global $FACE = [2, 3, 4, 5, 6, 7, 8, 9, 10, "J", "Q", "K", "A"]
Global $DECK[52]

; ## CREATES A NEW DECK
Func NewDeck()

	For $i = 0 To 3
		For $x = 0 To 12
			_ArrayPush($DECK, $FACE[$x] & $SUIT[$i])
		Next
	Next

EndFunc   ;==>NewDeck

; ## SHUFFLE DECK
Func Shuffle()

	_ArrayShuffle($DECK)

EndFunc   ;==>Shuffle

; ## DEAL A CARD
Func Deal()

	Return _ArrayPop($DECK)

EndFunc   ;==>Deal

; ## PRINT DECK
Func Print()

	ConsoleWrite(_ArrayToString($DECK) & @CRLF)

EndFunc   ;==>Print


#Region ;#### USAGE ####
NewDeck()
Print()
Shuffle()
Print()
ConsoleWrite("DEALT: " & Deal() & @CRLF)
Print()
#EndRegion ;#### USAGE ####
