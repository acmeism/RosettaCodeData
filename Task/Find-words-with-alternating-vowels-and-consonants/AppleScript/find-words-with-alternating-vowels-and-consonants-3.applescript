-- Task code:
local theText
set theText to (read file ((path to desktop as text) & "unixdict.txt") as «class utf8»)
findWordsWithAlternatingVowelsAndConsonants from theText with yAsVowel given minLength:10
