# syntax: GAWK -f WORD_WHEEL.AWK letters unixdict.txt
#         the required letter must be first
#
# example: GAWK -f WORD_WHEEL.AWK Kndeogelw unixdict.txt
#
BEGIN {
    letters = tolower(ARGV[1])
    required = substr(letters,1,1)
    size = 3
    ARGV[1] = ""
}
{   word = tolower($0)
    leng_word = length(word)
    if (word ~ required && leng_word >= size) {
      hits = 0
      for (i=1; i<=leng_word; i++) {
        if (letters ~ substr(word,i,1)) {
          hits++
        }
      }
      if (leng_word == hits && hits >= size) {
        for (i=1; i<=leng_word; i++) {
          c = substr(word,i,1)
          if (gsub(c,"&",word) > gsub(c,"&",letters)) {
            next
          }
        }
        words++
        printf("%s ",word)
      }
    }
}
END {
    printf("\nletters: %s, '%s' required, %d words >= %d characters\n",letters,required,words,size)
    exit(0)
}
