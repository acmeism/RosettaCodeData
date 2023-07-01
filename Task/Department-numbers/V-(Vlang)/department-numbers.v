fn main() {
    println("Police  Sanitation  Fire")
    println("------  ----------  ----")
    mut count := 0
    for i := 2; i < 7; i += 2 {
        for j in 1..8 {
            if j == i { continue }
            for k in 1..8 {
                if k == i || k == j { continue }
                if i + j + k != 12 { continue }
                println("  $i         $j         $k")
                count++
            }
        }
    }
    println("\n$count valid combinations")
}
