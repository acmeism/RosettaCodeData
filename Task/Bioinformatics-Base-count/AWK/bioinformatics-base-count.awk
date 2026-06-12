# syntax: GAWK -f BIOINFORMATICS_BASE_COUNT.AWK
# converted from FreeBASIC
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    dna = "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG" \
          "CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG" \
          "AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT" \
          "GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT" \
          "CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG" \
          "TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA" \
          "TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT" \
          "CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG" \
          "TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC" \
          "GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT"
    curr = first = 1
    while (curr <= length(dna)) {
      curr_base = substr(dna,curr,1)
      base_arr[curr_base]++
      rec = sprintf("%s%s",rec,curr_base)
      curr++
      if (curr % 10 == 1) {
        rec = sprintf("%s ",rec)
      }
      if (curr % 50 == 1) {
        printf("%3d-%3d: %s\n",first,curr-1,rec)
        rec = ""
        first = curr
      }
    }
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    printf("\nBase count\n")
    for (i in base_arr) {
      printf("%s %8d\n",i,base_arr[i])
      total += base_arr[i]
    }
    printf("%10d total\n",total)
    exit(0)
}
