["1 2 3 4 5 6 7 8 7 6 5 4 3 2 1", "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"].each { dataset ->
    println "  Dataset: $dataset"
    println "Sparkline: ${sparkline(dataset)}"
}
