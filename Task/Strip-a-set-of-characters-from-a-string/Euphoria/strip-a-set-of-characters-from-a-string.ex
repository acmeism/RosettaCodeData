include std\sequence.e
include std\console.e

sequence originalString = "She was a soul stripper. She took my heart!"
puts(1,"Before : " & originalString & "\n")
originalString = transmute(originalString, {{} , "a", "e", "i"}, {{} , "", "", ""})
puts(1,"After : " & originalString & "\n")
any_key()
