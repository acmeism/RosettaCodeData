import unicode, strformat

proc checkUniqueChars(s: string) =

  echo fmt"Checking string ""{s}"":"
  let runes = s.toRunes
  for i in 0..<runes.high:
    let rune = runes[i]
    for j in (i+1)..runes.high:
      if runes[j] == rune:
        echo "The string contains duplicate characters."
        echo fmt"Character {rune} ({int(rune):x}) is present at positions {i+1} and {j+1}."
        echo ""
        return
  echo "All characters in the string are unique."
  echo ""

const Strings = ["",
                 ".",
                 "abcABC",
                 "XYZ ZYX",
                 "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
                 "hétérogénéité",
                 "🎆🎃🎇🎈",
                 "😍😀🙌💃😍🙌",
                 "🐠🐟🐡🦈🐬🐳🐋🐡"]

for s in Strings:
  s.checkUniqueChars()
