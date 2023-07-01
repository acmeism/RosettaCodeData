import "/sort" for Sort

var a = (1..13).map { |i| "%(i)" }.toList
Sort.quick(a)
System.print(a)
