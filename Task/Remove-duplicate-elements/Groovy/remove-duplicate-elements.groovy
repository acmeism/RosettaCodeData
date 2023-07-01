def list = [1, 2, 3, 'a', 'b', 'c', 2, 3, 4, 'b', 'c', 'd']
assert list.size() == 12
println "             Original List: ${list}"

// Filtering the List (non-mutating)
def list2 = list.unique(false)
assert list2.size() == 8
assert list.size() == 12
println "             Filtered List: ${list2}"

// Filtering the List (in place)
list.unique()
assert list.size() == 8
println "   Original List, filtered: ${list}"

def list3 = [1, 2, 3, 'a', 'b', 'c', 2, 3, 4, 'b', 'c', 'd']
assert list3.size() == 12

// Converting to Set
def set = list as Set
assert set.size() == 8
println "                       Set: ${set}"
