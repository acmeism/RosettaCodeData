var s1 : Set<Int> = [1, 2, 3, 4]
let s2 : Set<Int> = [3, 4, 5, 6]
println(s1.union(s2)) // union; prints "[5, 6, 2, 3, 1, 4]"
println(s1.intersect(s2)) // intersection; prints "[3, 4]"
println(s1.subtract(s2)) // difference; prints "[2, 1]"
println(s1.isSubsetOf(s1)) // subset; prints "true"
println(Set<Int>([3, 1]).isSubsetOf(s1)) // subset; prints "true"
println(s1.isStrictSubsetOf(s1)) // proper subset; prints "false"
println(Set<Int>([3, 1]).isStrictSubsetOf(s1)) // proper subset; prints "true"
println(Set<Int>([3, 2, 4, 1]) == s1) // equality; prints "true"
println(s1 == s2) // equality; prints "false"
println(s1.contains(2)) // membership; prints "true"
println(Set<Int>([1, 2, 3, 4]).isSupersetOf(s1)) // superset; prints "true"
println(Set<Int>([1, 2, 3, 4]).isStrictSupersetOf(s1)) // proper superset; prints "false"
println(Set<Int>([1, 2, 3, 4, 5]).isStrictSupersetOf(s1)) // proper superset; prints "true"
println(s1.exclusiveOr(s2)) // symmetric difference; prints "[5, 6, 2, 1]"
println(s1.count) // cardinality; prints "4"
s1.insert(99) // mutability
println(s1) // prints "[99, 2, 3, 1, 4]"
s1.remove(99) // mutability
println(s1) // prints "[2, 3, 1, 4]"
s1.unionInPlace(s2) // mutability
println(s1) // prints "[5, 6, 2, 3, 1, 4]"
s1.subtractInPlace(s2) // mutability
println(s1) // prints "[2, 1]"
s1.exclusiveOrInPlace(s2) // mutability
println(s1) // prints "[5, 6, 2, 3, 1, 4]"
