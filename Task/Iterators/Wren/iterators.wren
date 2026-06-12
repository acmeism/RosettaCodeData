import "./llist" for DLinkedList

// Use iterators to print all elements of the sequence.
var printAll = Fn.new { |seq|
    var iter = null
    while (iter = seq.iterate(iter)) System.write("%(seq.iteratorValue(iter)) ")
    System.print()
}

// Use iterators to print just the first, fourth and fifth elements of the sequence.
var printFirstFourthFifth = Fn.new { |seq|
    var iter = null
    iter = seq.iterate(iter)
    System.write("%(seq.iteratorValue(iter)) ")  // first
    for (i in 1..3) iter = seq.iterate(iter)
    System.write("%(seq.iteratorValue(iter)) ")  // fourth
    iter = seq.iterate(iter)
    System.print(seq.iteratorValue(iter))        // fifth
}

// built in list (elements stored contiguously)
var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

// custom doubly linked list
var colors = DLinkedList.new(["Red", "Orange", "Yellow", "Green", "Blue", "Purple"])

System.print("All elements:")
printAll.call(days)
printAll.call(colors)

System.print("\nFirst, fourth, and fifth elements:")
printFirstFourthFifth.call(days)
printFirstFourthFifth.call(colors)

System.print("\nReverse first, fourth, and fifth elements:")
printFirstFourthFifth.call(days[-1..0])
printFirstFourthFifth.call(colors.reversed)
