import "./llist" for LinkedList
import "./iterate" for Reversed

var pangram = "Big fjords vex quick waltz nymph"
var elements = pangram.split(" ")
var sll = LinkedList.new(elements)

// iterate forwards
for (e in sll) System.write("%(e) ")
System.print("\n")

// iterate backwards without creating a list
for (i in sll.count-1..0) System.write("%(sll[i]) ")
System.print("\n")

// iterate backwards by creating a list internally
for (e in Reversed.new(sll)) System.write("%(e) ")
System.print("\n")

// reverse the linked list in place
var i = 0
var j = sll.count - 1
while (i < j) {
    sll.exchange(i, j)
    i = i + 1
    j = j - 1
}
// now we can iterate forwards
for (e in sll) System.write("%(e) ")
System.print()
