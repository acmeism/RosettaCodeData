import unicode

let s = "Hänsel  ««: 10,00€"
echo "Original: ", s
echo "With first character removed: ", s.runeSubStr(1)
echo "With last character removed: ", s.runeSubStr(0, s.runeLen - 1)
echo "With first and last characters removed: ", s.runeSubStr(1, s.runeLen - 2)
# Using the runes type and slices
let r = s.toRunes
echo "With first and last characters removed (other way): ", r[1 .. ^2]
