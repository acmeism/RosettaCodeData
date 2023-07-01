// create a list with 10 elements all initialized to zero
var squares = List.filled(10, 0)
// give them different values and print them
for (i in 0..9) squares[i] = i * i
System.print(squares)
// add another element to the list dynamically and print it again
squares.add(10 * 10)
System.print(squares)
squares = null // make eligible for GC
