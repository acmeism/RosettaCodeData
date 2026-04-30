mut transpose := [5][4]int{}
matrix := [[78,19,30,12,36], [49,10,65,42,50], [30,93,24,78,10], [39,68,27,64,29]]
for ial in 0..5 {
    for jal in 0..4 {
        transpose[ial][jal] = matrix[jal][ial]
        print("" + "${transpose[ial][jal]}" + " ")
    }
    println("")
}
