b=99
Loop, %b% {
s := b " bottles of beer on the wall, " b " bottles of beer, Take one down, pass it around " b-1 " bottles of beer on the wall"
b--
TrayTip,,%s%
sleep, 40
}
