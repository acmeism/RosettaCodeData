# syntax: GAWK -f GENERATE_LOWER_CASE_ASCII_ALPHABET.AWK
BEGIN {
    for (i=0; i<=255; i++) {
      c = sprintf("%c",i)
      if (c ~ /[[:lower:]]/) {
        lower_chars = lower_chars c
      }
    }
    printf("%s %d: %s\n",ARGV[0],length(lower_chars),lower_chars)
    exit(0)
}
