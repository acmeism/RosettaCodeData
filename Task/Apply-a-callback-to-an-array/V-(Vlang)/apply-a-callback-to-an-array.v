fn main() {
    mut arr := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    new_arr := arr.map(fn (it int) int {return it * it})
    println(new_arr)
}
