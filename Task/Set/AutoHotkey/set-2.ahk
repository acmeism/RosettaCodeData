A:= ["apple", "cherry", "elderberry", "grape"]
B:= ["banana", "cherry", "date", "elderberry", "fig"]
C:= ["apple", "cherry", "elderberry", "grape", "orange"]
D:= ["apple", "cherry", "elderberry", "grape"]
E:= ["apple", "cherry", "elderberry"]
M:= "banana"

Res =
(
A:= ["apple", "cherry", "elderberry", "grape"]
B:= ["banana", "cherry", "date", "elderberry", "fig"]
C:= ["apple", "cherry", "elderberry", "grape", "orange"]
D:= ["apple", "cherry", "elderberry", "grape"]
E:= ["apple", "cherry", "elderberry"]
M:= "banana"

)

Res .= "`nM is " (test(A,M)?"":"not ") "an element of Set A"
Res .= "`nM is " (test(B,M)?"":"not ") "an element of Set B"

Res .= "`nUnion(A,B) = "
for i, val in Union(A,B)
	Res.= (A_Index=1?"`t":", ") val

Res .= "`nintersection(A,B) = "
for i, val in intersection(A,B)
	Res.= (A_Index=1?"`t":", ") val

Res .= "`ndifference(A,B) = "
for i, val in difference(A,B)
	Res.= (A_Index=1?"`t":", ") val

Res .= "`n`nA is " (subset(A,C)?"":"not ") "a subset of Set C"
Res .= "`nA is " (subset(A,D)?"":"not ") "a subset of Set D"
Res .= "`nA is " (subset(A,E)?"":"not ") "a subset of Set E"

Res .= "`n`nA is " (equal(A,C)?"":"not ") "a equal to Set C"
Res .= "`nA is " (equal(A,D)?"":"not ") "a equal to Set D"
Res .= "`nA is " (equal(A,E)?"":"not ") "a equal to Set E"

MsgBox % Res
