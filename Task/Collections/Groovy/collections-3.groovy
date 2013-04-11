def emptySet = new HashSet()
assert emptySet.isEmpty() : "These are not the items you're looking for"
assert emptySet.size() == 0 : "Empty set has size 0"
assert ! emptySet : "Empty set evaluates as boolean 'false'"

def initializedSet = new HashSet([ 1, "b", java.awt.Color.BLUE ])
assert initializedSet.size() == 3
assert initializedSet : "Non-empty list evaluates as boolean 'true'"
//assert initializedSet[2] == java.awt.Color.BLUE  // SYNTAX ERROR!!! No indexing of set elements!

def combinedSet = initializedSet + new HashSet([ "more stuff", "even more stuff" ])
assert combinedSet.size() == 5

combinedSet << "even more stuff"
assert combinedSet.size() == 5 : "No duplicate elements allowed!"
println ([combinedSet: combinedSet])
