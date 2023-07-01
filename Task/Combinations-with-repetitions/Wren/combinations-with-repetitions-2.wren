import "./seq" for Lst
import "./perm" for Comb

var a = ["iced", "jam", "plain"]
a = Lst.flatten(Lst.zip(a, a))
System.print(Comb.listDistinct(a, 2))

a = (1..10).toList
a = Lst.flatten(Lst.zip(Lst.zip(a, a), a))
System.print(Comb.listDistinct(a, 3).count)
