import sets

var setA = ["John", "Bob", "Mary", "Serena"].toHashSet
var setB = ["Jim", "Mary", "John", "Bob"].toHashSet
echo setA -+- setB  # Symmetric difference
echo setA - setB    # Difference
echo setB - setA    # Difference
