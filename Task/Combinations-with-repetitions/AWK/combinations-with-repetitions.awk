# syntax: GAWK -f COMBINATIONS_WITH_REPETITIONS.AWK
BEGIN {
    n = split("iced,jam,plain",donuts,",")
    for (i=1; i<=n; i++) {
      for (j=1; j<=n; j++) {
        if (donuts[i] < donuts[j]) {
          key = sprintf("%s %s",donuts[i],donuts[j])
        }
        else {
          key = sprintf("%s %s",donuts[j],donuts[i])
        }
        arr[key]++
      }
    }
    cmd = "SORT"
    for (i in arr) {
      printf("%s\n",i) | cmd
      choices++
    }
    close(cmd)
    printf("choices = %d\n",choices)
    exit(0)
}
