import "./seq" for Lst

var l = (1..9).toList
System.print("Original list     : %(l)")
System.print("Shifted left by 3 : %(Lst.lshift(l, 3))")
