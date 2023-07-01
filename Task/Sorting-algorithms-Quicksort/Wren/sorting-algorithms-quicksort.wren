import "/sort" for Sort

var as = [
    [4, 65, 2, -31, 0, 99, 2, 83, 782, 1],
    [7, 5, 2, 6, 1, 4, 2, 6, 3],
    ["echo", "lima", "charlie", "whiskey", "golf", "papa", "alfa", "india", "foxtrot", "kilo"]
]
for (a in as) {
    System.print("Before: %(a)")
    Sort.quick(a)
    System.print("After : %(a)")
    System.print()
}
