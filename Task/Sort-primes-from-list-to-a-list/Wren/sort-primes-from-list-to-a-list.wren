import "./math" for Int

var lst = [2, 43, 81, 122, 63, 13, 7, 95, 103]
System.print(lst.where { |e| Int.isPrime(e) }.toList.sort())
