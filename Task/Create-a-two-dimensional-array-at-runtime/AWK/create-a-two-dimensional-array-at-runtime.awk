/[0-9]+ [0-9]+/ {
  for(i=0; i < $1; i++) {
    for(j=0; j < $2; j++) {
      arr[i, j] = i*j
    }
  }

  # how to scan "multidim" array as explained in the GNU AWK manual
  for (comb in arr) {
    split(comb, idx, SUBSEP)
    print idx[1] "," idx[2] "->" arr[idx[1], idx[2]]
  }
}
