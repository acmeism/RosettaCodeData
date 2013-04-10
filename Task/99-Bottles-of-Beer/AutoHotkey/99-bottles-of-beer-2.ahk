n=99
Gui, Font, s20 cMaroon, Comic Sans MS
Gui, Add, Text, w500 vLyrics, %n% bottles of beer on the wall...
Gui, Show
Loop {
 Sleep, 2000
 GuiControl,,Lyrics,% n!=1 ? n " bottles of beer.":n " bottle of beer."
 Sleep, 2000
 GuiControl,,Lyrics,% n ? "Take one down, pass it around...":"Go to the store, buy some more..."
 Sleep, 2000
 n := n ? --n:99
 GuiControl,,Lyrics,% n!=1 ? n " bottles of beer on the wall.":n " bottle of beer on the wall."
 Sleep, 2000
 GuiControl,,Lyrics,% n!=1 ? n " bottles of beer on the wall...":n " bottle of beer on the wall..."
}
GuiClose:
ExitApp
