' FB 1.05.0 Win64

Type Cat
  name As String
  age As Integer
End Type

Type CatInfoType As Sub (As Cat Ptr)

Sub printCatInfo(c As Cat Ptr)
  Print "Name "; c->name, "Age"; c-> age
  Print
End Sub

' create Cat object on heap and store a pointer to it
Dim c As Cat Ptr = New Cat

' set fields using the pointer and the "crow's foot" operator
c->name = "Fluffy"
c->age = 9

' print them out through a procedure pointer
Dim cit As CatInfoType = ProcPtr(printCatInfo)
cit(c)

Delete c
c = 0

Dim i As Integer = 3
' create an integer pointer variable and set it to the address of 'i'
Dim pi As Integer Ptr = @i

'change the variable through the pointer
*pi = 4

'print out the result
print "i ="; *pi

'create a reference to the variable i
Dim ByRef As Integer j = i

' set j (and hence i) to a new value
j = 5

' print them out
Print "i ="; i, "j ="; j
Sleep
