# syntax: GAWK -f WORDS_FROM_NEIGHBOUR_ONES.AWK unixdict.txt
{   if (length($0) < 9) { next }
    arr1[++n] = $0
    arr2[$0] = ""
}
END {
    for (i=1; i<=n; i++) {
      word = substr(arr1[i],1,1)
      for (j=2; j<=9; j++) {
        if (!((i+j) in arr1)) { continue }
        word = word substr(arr1[i+j],j,1)
      }
      if (word in arr2) {
        printf("%s\n",word)
        delete arr2[word] # eliminate duplicates
      }
    }
    exit(0)
}
