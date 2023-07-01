# syntax: GAWK -f SEMORDNILAP.AWK unixdict.txt
{ arr[$0]++ }
END {
    PROCINFO["sorted_in"] = "@ind_str_asc"
    for (word in arr) {
      rword = ""
      for (j=length(word); j>0; j--) {
        rword = rword substr(word,j,1)
      }
      if (word == rword) { continue } # palindrome
      if (rword in arr) {
        if (word in shown || rword in shown) { continue }
        shown[word]++
        shown[rword]++
        if (n++ < 5) { printf("%s %s\n",word,rword) }
      }
    }
    printf("%d words\n",n)
    exit(0)
}
