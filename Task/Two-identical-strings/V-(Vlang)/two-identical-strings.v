import strconv

fn main() {
    mut i := i64(1)
    for {
        mut b2 := '${i:b}'
        b2 += b2
        d := strconv.parse_int(b2,2,16)!
        if d >= 1000 {
            break
        }
        println("$d : $b2")
        i++
    }
    println("\nFound ${i-1} numbers.")
}
