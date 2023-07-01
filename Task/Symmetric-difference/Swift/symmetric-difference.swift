let setA : Set<String> = ["John", "Bob", "Mary", "Serena"]
let setB : Set<String> = ["Jim", "Mary", "John", "Bob"]
println(setA.exclusiveOr(setB)) // symmetric difference of A and B
println(setA.subtract(setB)) // elements in A that are not in B
