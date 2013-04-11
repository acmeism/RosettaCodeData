var linkedList := [1, [2, [3, [4, [5, [6, [7, null]]]]]]]

while (linkedList =~ [value, next]) {
    println(value)
    linkedList := next
}
