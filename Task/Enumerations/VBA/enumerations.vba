'this enumerates from 0
Enum fruits
  apple
  banana
  cherry
End Enum

'here we use our own enumeration
Enum fruits2
  pear = 5
  mango = 10
  kiwi = 20
  pineapple = 20
End Enum


Sub test()
Dim f As fruits
  f = apple
  Debug.Print "apple equals "; f
  Debug.Print "kiwi equals "; kiwi
  Debug.Print "cherry plus kiwi plus pineapple equals "; cherry + kiwi + pineapple
End Sub
