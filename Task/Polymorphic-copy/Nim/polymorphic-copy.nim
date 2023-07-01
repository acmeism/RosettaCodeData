type
  T = ref object of RootObj
    myValue: string
  S1 = ref object of T
  S2 = ref object of T

method speak(x: T) {.base.} = echo "T Hello ", x.myValue
method speak(x: S1) = echo "S1 Meow ", x.myValue
method speak(x: S2) = echo "S2 Woof ", x.myValue

echo "creating initial objects of types S1, S2, and T."
var a = S1(myValue: "Green")
a.speak
var b = S2(myValue: "Blue")
b.speak
var u = T(myValue: "Blue")
u.speak

echo "Making copy of a as u; colors and types should match."
u.deepCopy(a)
u.speak
a.speak

echo "Assigning new color to u; A's color should be unchanged."
u.myValue = "Orange"
u.speak
a.speak

echo "Assigning u to reference same object as b; colors and types should match."
u = b
u.speak
b.speak

echo "Assigning new color to u. Since u,b reference the same object, b's color changes as well."
u.myValue = "Yellow"
u.speak
b.speak
