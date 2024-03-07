import "./sort" for Find

var a = [9, 8, 7, 6, 5, 0, 1, 2, 3, 4]
for (k in 0..9) {
    System.write(Find.quick(a, k))
    if (k < 9) System.write(", ")
}
System.print()
