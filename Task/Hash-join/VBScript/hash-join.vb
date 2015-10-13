Dim t_age(4,1)
t_age(0,0) = 27 : t_age(0,1) = "Jonah"
t_age(1,0) = 18 : t_age(1,1) = "Alan"
t_age(2,0) = 28 : t_age(2,1) = "Glory"
t_age(3,0) = 18 : t_age(3,1) = "Popeye"
t_age(4,0) = 28 : t_age(4,1) = "Alan"

Dim t_nemesis(4,1)
t_nemesis(0,0) = "Jonah" : t_nemesis(0,1) = "Whales"
t_nemesis(1,0) = "Jonah" : t_nemesis(1,1) = "Spiders"
t_nemesis(2,0) = "Alan" : t_nemesis(2,1) = "Ghosts"
t_nemesis(3,0) = "Alan" : t_nemesis(3,1) = "Zombies"
t_nemesis(4,0) = "Glory" : t_nemesis(4,1) = "Buffy"

Call hash_join(t_age,1,t_nemesis,0)

Sub hash_join(table_1,index_1,table_2,index_2)
	Set hash = CreateObject("Scripting.Dictionary")
	For i = 0 To UBound(table_1)
		hash.Add i,Array(table_1(i,0),table_1(i,1))
	Next
	For j = 0 To UBound(table_2)
		For Each key In hash.Keys
			If hash(key)(index_1) = table_2(j,index_2) Then
				WScript.StdOut.WriteLine hash(key)(0) & "," & hash(key)(1) &_
					" = " & table_2(j,0) & "," & table_2(j,1)
			End If
		Next
	Next
End Sub
