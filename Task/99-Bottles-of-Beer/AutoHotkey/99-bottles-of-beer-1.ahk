; RC: 99 bottles of beer
   b = 99
   Loop, %b% {
      s .= b . " bottles of beer on the wall,`n"
        . b . " bottles of beer.`nTake one down, pass it around,`n"
        . b-1 . " bottles of beer on the wall.`n`n"
      b--
   }
   Gui, Add, Edit, w200 h200, %s%
   Gui, Show, , 99 bottles of beer
Return ; end of auto-execute section

GuiClose:
   ExitApp
Return
