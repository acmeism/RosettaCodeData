fn index_of(l []int, n int) int {
    for i in 0..l.len {
        if l[i] == n {return i}
    }
    return -1
}

fn common2(l1 []int, l2 []int) []int {
    // minimize number of lookups
    c1, c2 := l1.len, l2.len
    mut shortest, mut longest := l1.clone(), l2.clone()
    if c1 > c2 {shortest, longest = l2.clone(), l1.clone()}
    mut longest2 := longest.clone()
    mut res := []int{}
    for e in shortest {
        ix := index_of(longest2, e)
        if ix >= 0 {
            res << e
            longest2 << longest2[ix+1..]
        }
    }
    return res
}

fn common_n(ll [][]int) []int {
    n := ll.len
    if n == 0 {return []int{}}
    if n == 1 {return ll[0]}
    mut res := common2(ll[0], ll[1])
    if n == 2 {return res}
    for l in ll[2..] {
        res = common2(res, l)
    }
    return res
}

fn main() {
    lls := [
        [[2, 5, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 9, 8, 4], [1, 3, 7, 6, 9]],
        [[2, 2, 1, 3, 8, 9, 4, 6], [3, 5, 6, 2, 2, 2, 4], [2, 3, 7, 6, 2]],
    ]
    for ll in lls {
        println("Intersection of $ll is:")
        println(common_n(ll))
        println("")
    }
}
