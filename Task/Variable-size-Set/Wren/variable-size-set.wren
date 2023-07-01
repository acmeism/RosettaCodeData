// create a list with 10 elements all initialized to zero
var l = List.filled(10, 0)
// give them different values and print them
for (i in 0..9) l[i] = i
System.print(l)
// add another element to the list dynamically and print it again
l.add(10)
System.print(l)
