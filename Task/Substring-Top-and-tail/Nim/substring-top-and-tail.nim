import unicode

let s = "Hänsel  ««: 10,00€"
echo(s.runeSubStr(1))
echo(s.runeSubStr(0, -1))
echo(s.runeSubStr(1, -1))
# using the runes type and slices
let r = s.toRunes
echo(r[1 .. ^2])
