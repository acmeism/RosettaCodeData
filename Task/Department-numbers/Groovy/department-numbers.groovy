class DepartmentNumbers {
    static void main(String[] args) {
        println("Police  Sanitation  Fire")
        println("------  ----------  ----")
        int count = 0
        for (int i = 2; i <= 6; i += 2) {
            for (int j = 1; j <= 7; ++j) {
                if (j == i) continue
                for (int k = 1; k <= 7; ++k) {
                    if (k == i || k == j) continue
                    if (i + j + k != 12) continue
                    println("  $i         $j         $k")
                    count++
                }
            }
        }
        println()
        println("$count valid combinations")
    }
}
