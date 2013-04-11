def emptyList = []
assert emptyList.isEmpty() : "These are not the items you're looking for"
assert emptyList.size() == 0 : "Empty list has size 0"
assert ! emptyList : "Empty list evaluates as boolean 'false'"

def initializedList = [ 1, "b", java.awt.Color.BLUE ]
assert initializedList.size() == 3
assert initializedList : "Non-empty list evaluates as boolean 'true'"
assert initializedList[2] == java.awt.Color.BLUE : "referencing a single element (zero-based indexing)"
assert initializedList[-1] == java.awt.Color.BLUE : "referencing a single element (reverse indexing of last element)"

def combinedList = initializedList + [ "more stuff", "even more stuff" ]
assert combinedList.size() == 5
assert combinedList[1..3] == ["b", java.awt.Color.BLUE, "more stuff"] : "referencing a range of elements"

combinedList << "even more stuff"
assert combinedList.size() == 6
assert combinedList[-1..-3] == \
        ["even more stuff", "even more stuff", "more stuff"] \
                : "reverse referencing last 3 elements"
println ([combinedList: combinedList])
