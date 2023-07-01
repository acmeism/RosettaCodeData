# syntax: GAWK -f IDIOMATICALLY_DETERMINE_ALL_THE_LOWERCASE_AND_UPPERCASE_LETTERS.AWK
BEGIN {
    for (i=0; i<=255; i++) {
      c = sprintf("%c",i)
      if (c ~ /[[:lower:]]/) {
        lower_chars = lower_chars c
      }
      if (c ~ /[[:upper:]]/) {
        upper_chars = upper_chars c
      }
    }
    printf("%s\n",ARGV[0])
    printf("lowercase %d: %s\n",length(lower_chars),lower_chars)
    printf("uppercase %d: %s\n",length(upper_chars),upper_chars)
    exit(0)
}
