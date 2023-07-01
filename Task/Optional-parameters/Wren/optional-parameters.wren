import "./sort" for Cmp, Sort
import "./seq" for Lst

class TableSorter {
   // uses 'merge' sort to avoid mutating original table
   // column is zero based
   static sort(table, ordering, column, reverse) {
       if (ordering == null) ordering = Fn.new { |r1, r2| Cmp.string.call(r1[column], r2[column]) }
       var sorted = Sort.merge(table, ordering)
       if (reverse) Lst.reverse(sorted)
       return sorted
   }

   // overloads to simulate optional parameters
   static sort(table)                   { sort(table, null, 0, false) }
   static sort(table, ordering)         { sort(table, ordering, 0, false) }
   static sort(table, ordering, column) { sort(table, ordering, column, false) }
}

var table = [
    ["first", "1"],
    ["second", "2"],
    ["fourth", "4"],
    ["fifth", "5"],
    ["third", "3"]
]

System.print("Original table:")
System.print(table.join("\n"))

System.print("\nAfter lexicographic sort by first column:")
var table2 = TableSorter.sort(table)
System.print(table2.join("\n"))

System.print("\nAfter sorting in length order of first column:")
var ordering = Fn.new { |r1, r2| (r1[0].count - r2[0].count).sign }
table2 = TableSorter.sort(table, ordering)
System.print(table2.join("\n"))

System.print("\nAfter lexicographic sort by second column:")
table2 = TableSorter.sort(table, null, 1)
System.print(table2.join("\n"))

System.print("\nAfter reverse lexicographic sort by second column:")
table2 = TableSorter.sort(table, null, 1, true)
System.print(table2.join("\n"))
