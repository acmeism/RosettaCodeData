def digitCounts = tallyFirstDigits(1000, aFib)
println "d    actual    predicted"
(1..<10).each {
    printf ("%d %10.6f %10.6f\n", it, digitCounts[it]/1000, Math.log10(1.0 + 1.0/it))
}
