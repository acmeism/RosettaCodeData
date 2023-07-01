import "/dynamic" for Enum

var Fruit = Enum.create("Fruit", ["apple", "orange", "pear", "cherry", "banana", "grape"], 1)
System.print(Fruit.orange)
System.print(Fruit.members[Fruit.cherry - 1])
