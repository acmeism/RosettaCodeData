[(0..3), (2..8).step(2)].each { seq ->
    println "fsf1$seq = ${fsf1(seq)}"
    println "fsf2$seq = ${fsf2(seq)}"
}
