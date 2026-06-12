fn main() {
    dna := "" +
        "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" +
        "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" +
        "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" +
        "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" +
        "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" +
        "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" +
        "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" +
        "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" +
        "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" +
        "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"

    println("SEQUENCE:")
    le := dna.len
    for i := 0; i < le; i += 50 {
        mut k := i + 50
        if k > le {
            k = le
        }
        println("${i:5}: ${dna[i..k]}")
    }
    mut base_map := map[byte]int{} // allows for 'any' base
    for i in 0..le {
        base_map[dna[i]]++
    }
    mut bases := base_map.keys()
	bases.sort()

    println("\nBASE COUNT:")
    for base in bases {
        println("    $base: ${base_map[base]:3}")
    }
    println("    ------")
    println("    Σ: $le")
    println("    ======")
}
