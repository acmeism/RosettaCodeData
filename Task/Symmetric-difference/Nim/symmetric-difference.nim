import sets

var setA = ["John", "Bob", "Mary", "Serena"].toSet
var setB = ["Jim", "Mary", "John", "Bob"].toSet
echo setA -+- setB # Symmetric difference
echo setA - setB # Difference
echo setB - setA # Difference
