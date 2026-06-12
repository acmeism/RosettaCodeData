fn main() {
    lists := [
        [9, 3, 3, 3, 2, 1, 7, 8, 5],
        [5, 2, 9, 3, 3, 7, 8, 4, 1],
        [1, 4, 3, 6, 7, 3, 8, 3, 2],
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
        [4, 6, 8, 7, 2, 3, 3, 3, 1],
        [3, 3, 3, 1, 2, 4, 5, 1, 3],
        [0, 3, 3, 3, 3, 7, 2, 2, 6],
        [3, 3, 3, 3, 3, 4, 4, 4, 4],
    ]
    for d := 1; d <= 4; d++ {
        println("Exactly $d adjacent $d's:")
        for list in lists {
            mut indices := []int{}
            for i, e in list {
                if e == d {indices << i}
            }
            mut adjacent := false
            if indices.len == d {
                adjacent = true
                for i in 1..indices.len {
                    if indices[i]-indices[i-1] != 1 {
                        adjacent = false
                        break
                    }
                }
            }
            println("$list -> $adjacent")
        }
        println("")
    }
}
