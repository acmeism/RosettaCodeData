import "./sort" for Sort

var array = [ [4, 65, 2, -31, 0, 99, 2, 83, 782, 1], [7, 5, 2, 6, 1, 4, 2, 6, 3] ]
for (a in array) {
    System.print("Before: %(a)")
    Sort.shell(a)
    System.print("After : %(a)")
    System.print()
}
