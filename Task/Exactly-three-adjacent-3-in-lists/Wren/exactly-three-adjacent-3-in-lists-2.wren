for (d in 1..4) {
    System.print("Exactly %(d) adjacent %(d)'s:")
    for (list in lists) {
        var condition = list.count { |n| n == d } == d && Lst.isSliceOf(list, [d] * d)
        System.print("%(list) -> %(condition)")
    }
    System.print()
}
