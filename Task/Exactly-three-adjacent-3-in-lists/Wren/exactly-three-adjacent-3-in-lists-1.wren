import "./seq" for Lst

var lists = [
    [9,3,3,3,2,1,7,8,5],
    [5,2,9,3,3,7,8,4,1],
    [1,4,3,6,7,3,8,3,2],
    [1,2,3,4,5,6,7,8,9],
    [4,6,8,7,2,3,3,3,1],
    [3,3,3,1,2,4,5,1,3],
    [0,3,3,3,3,7,2,2,6],
    [3,3,3,3,3,4,4,4,4]
]
System.print("Exactly three adjacent 3's:")
for (list in lists) {
    var condition = list.count { |n| n == 3 } == 3 && Lst.isSliceOf(list, [3, 3, 3])
    System.print("%(list) -> %(condition)")
}
