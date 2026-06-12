var a = [6, 81, 243, 14, 25, 49, 123, 69, 11]

while (a.count > 1) {
    a.sort()
    System.print("Sorted list: %(a)")
    var sum = a[0] + a[1]
    System.print("Two smallest: %(a[0]) + %(a[1]) = %(sum)")
    a.add(sum)
    a = a[2..-1]
}

System.print("Last item is %(a[0]).")
