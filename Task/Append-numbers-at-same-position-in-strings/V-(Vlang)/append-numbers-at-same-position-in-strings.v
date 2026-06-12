fn main() {
    list1 := [1, 2, 3, 4, 5, 6, 7, 8, 9]!
    list2 := [10, 11, 12, 13, 14, 15, 16, 17, 18]!
    list3 := [19, 20, 21, 22, 23, 24, 25, 26, 27]!
    mut list := [9]int{}
    for i in 0..9 {
        list[i] = list1[i]*int(1e4) + list2[i]*int(1e2) + list3[i]
    }
    println(list)
}
