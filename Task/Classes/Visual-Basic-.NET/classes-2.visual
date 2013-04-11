'Declare and create separately
Dim foo1 As Foo
foo1 = New Foo

'Declare and create at the same time
Dim foo2 As New Foo

'... while passing constructor parameters
Dim foo3 As New Foo(5)

'... and them immediately set properties
Dim foo4 As New Foo With {.Bar = 10}

'Calling a method that returns a value
Console.WriteLine(foo4.MultiplyBar(20))

'Calling a method that performs an action
foo4.DoubleBar()

'Reading/writing properties
Console.WriteLine(foo4.Bar)
foo4.Bar = 1000
