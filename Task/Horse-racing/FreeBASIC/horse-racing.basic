' Ratings on past form, assuming a rating of 100 for horse A.
Dim As Double a = 100.0
Dim As Double b = a - 8 - 2 * 2       ' carried 8 lbs less, finished 2 lengths behind.
Dim As Double c = a + 4 - 2 * 3.5
Dim As Double d = a - 4 - 10 * 0.4    ' based on relative weight and time.
Dim As Double e = d + 7 - 2 * 1
Dim As Double f = d + 11 - 2 * (4 - 2)
Dim As Double g = a - 10  + 10 * 0.2
Dim As Double h = g + 6 - 2 * 1.5
Dim As Double i = g + 15 - 2 * 2

' Adjustments to ratings for current race.
b += 4
c -= 4
h += 3
Dim As Double j = a - 3 + 10 * 0.2

' Filly's allowance to give weight adjusted weighting.
b += 3
d += 3
i += 3
j += 3

' Create table mapping horse to its weight adjusted rating and whether colt.
Type Pair
    key As String*1
    rating As Double
    colt As Boolean
End Type

Dim As Pair list(9)
list(0).key = "A": list(0).rating = a: list(0).colt = True
list(1).key = "B": list(1).rating = b: list(1).colt = False
list(2).key = "C": list(2).rating = c: list(2).colt = True
list(3).key = "D": list(3).rating = d: list(3).colt = False
list(4).key = "E": list(4).rating = e: list(4).colt = True
list(5).key = "F": list(5).rating = f: list(5).colt = True
list(6).key = "G": list(6).rating = g: list(6).colt = True
list(7).key = "H": list(7).rating = h: list(7).colt = True
list(8).key = "I": list(8).rating = i: list(8).colt = False
list(9).key = "J": list(9).rating = j: list(9).colt = False

' Sort in descending order of rating.
Dim As Integer n = Ubound(list)
For x As Integer = 0 To n - 1
    For y As Integer = 0 To n - x - 1
        If list(y).rating < list(y + 1).rating Then Swap list(y), list(y + 1)
    Next y
Next x

' Show expected result of race.
Print !"Race 4\n"
Print "Pos Horse  Weight  Dist  Sex"
Dim As String posic = ""
For x As Integer = Lbound(list) To Ubound(list)
    Dim As Double wt = Iif(list(x).colt, 9.00, 8.11)
    Dim As Double dist = 0.0
    If x > 0 Then dist = (list(x-1).rating - list(x).rating) * 0.5
    posic = Iif(x = 0 Or dist > 0, Str(x + 1), Iif(Right(posic, 1) <> "=", Str(x) & "=", posic))
    Dim As String sx = Iif(list(x).colt, "colt", "filly")
    Print Using "\\   !     ##.##   #.#   \       \"; posic; list(x).key; wt; dist; sx
Next x

' Weight adjusted rating of winner.
Dim As Double wr = list(0).rating

' Expected time of winner (relative to A's time in Race 1).
Dim As Double t = 96 - (wr - 100) / 10
Dim As Integer min = Int(t / 60)
Dim As Integer sec = t Mod 60
Print
Print Using "Time ## minute ##.# seconds"; min; sec

Sleep
