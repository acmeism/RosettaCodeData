import "./sort" for Cmp, Sort

var data = [ ["UK", "London"], ["US", "New York"], ["US", "Birmingham"], ["UK", "Birmingham"] ]

// for sorting by country
var cmp = Fn.new { |p1, p2| Cmp.string.call(p1[0], p2[0]) }

// for sorting by city
var cmp2 = Fn.new { |p1, p2| Cmp.string.call(p1[1], p2[1]) }

System.print("Initial data:")
System.print("  " + data.join("\n  "))

System.print("\nSorted by country:")
var data2 = data.toList
Sort.insertion(data2, cmp)
System.print("  " + data2.join("\n  "))

System.print("\nSorted by city:")
var data3 = data.toList
Sort.insertion(data3, cmp2)
System.print("  " + data3.join("\n  "))
