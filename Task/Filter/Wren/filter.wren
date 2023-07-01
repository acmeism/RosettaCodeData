var a = [1, 4, 17, 8, -21, 6, -11, -2, 18, 31]
System.print("The original array is       : %(a)")

System.print("\nFiltering to a new array    :-")
var evens = a.where { |e| e%2 == 0 }.toList
System.print("The even numbers are        : %(evens)")
System.print("The original array is still : %(a)")

// Destructive filter, permanently remove even numbers.
evens.clear()
for (i in a.count-1..0) {
    if (a[i]%2 == 0) {
        evens.add(a[i])
        a.removeAt(i)
    }
}
evens = evens[-1..0]
System.print("\nAfter a destructive filter  :-")
System.print("The even numbers are        : %(evens)")
System.print("The original array is now   : %(a)")
