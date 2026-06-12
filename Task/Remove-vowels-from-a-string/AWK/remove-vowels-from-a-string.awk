# syntax: GAWK -f REMOVE_VOWELS_FROM_A_STRING.AWK
BEGIN {
    IGNORECASE = 1
    arr[++n] = "The AWK Programming Language"
    arr[++n] = "The quick brown fox jumps over the lazy dog"
    for (i=1; i<=n; i++) {
      str = arr[i]
      printf("old: %s\n",str)
      gsub(/[aeiou]/,"",str)
      printf("new: %s\n\n",str)
    }
    exit(0)
}
