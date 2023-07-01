def emptyMap = [:]
assert emptyMap.isEmpty() : "These are not the items you're looking for"
assert emptyMap.size() == 0 : "Empty map has size 0"
assert ! emptyMap : "Empty map evaluates as boolean 'false'"

def initializedMap = [ count: 1, initial: "B", eyes: java.awt.Color.BLUE ]
assert initializedMap.size() == 3
assert initializedMap : "Non-empty map evaluates as boolean 'true'"
assert initializedMap["eyes"] == java.awt.Color.BLUE : "referencing a single element (array syntax)"
assert initializedMap.eyes == java.awt.Color.BLUE : "referencing a single element (member syntax)"
assert initializedMap.height == null : \
        "references to non-existant keys generally evaluate to null (implementation dependent)"

def combinedMap = initializedMap \
        + [hair: java.awt.Color.BLACK, birthdate: Date.parse("yyyy-MM-dd", "1960-05-17") ]
assert combinedMap.size() == 5

combinedMap["weight"] = 185        // array syntax
combinedMap.lastName = "Smith"     // member syntax
combinedMap << [firstName: "Joe"]  // entry syntax
assert combinedMap.size() == 8
assert combinedMap.keySet().containsAll(
        ["lastName", "count", "eyes", "hair", "weight", "initial", "firstName", "birthdate"])
println ([combinedMap: combinedMap])
