Type Data1
    value As Integer
    key As String
End Type

Type Data2
    key As String
    value As String
End Type

Dim table1(5) As Data1
Dim table2(5) As Data2

table1(1).value = 27: table1(1).key = "Jonah"
table1(2).value = 18: table1(2).key = "Alan"
table1(3).value = 28: table1(3).key = "Glory"
table1(4).value = 18: table1(4).key = "Popeye"
table1(5).value = 28: table1(5).key = "Alan"

table2(1).key = "Jonah": table2(1).value = "Whales"
table2(2).key = "Jonah": table2(2).value = "Spiders"
table2(3).key = "Alan": table2(3).value = "Ghosts"
table2(4).key = "Alan": table2(4).value = "Zombies"
table2(5).key = "Glory": table2(5).value = "Buffy"

Print String(51, "-")
Print " Age     | Name          || Name         | Nemesis"
Print String(51, "-")

For i As Integer = 1 To 5
    For j As Integer = 1 To 5
        If table1(i).key = table2(j).key Then
            Print Using " ##      | \         \   || \         \  | \      \"; table1(i).value; table1(i).key; table2(j).key; table2(j).value
        End If
    Next j
Next i

Sleep
