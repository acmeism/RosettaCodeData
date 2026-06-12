# syntax: GAWK -f COUNT_HOW_MANY_VOWELS_AND_CONSONANTS_OCCUR_IN_A_STRING.AWK
BEGIN {
    str = "Now is the time for all good men to come to the aid of their country."
    printf("%s\n",str)
    str = toupper(str)
    for (i=1; i<=length(str); i++) {
      if (substr(str,i,1) ~ /[AEIOU]/) {
        count_vowels++
      }
      else if (substr(str,i,1) ~ /[BCDFGHJKLMNPQRSTVWXYZ]/) {
        count_consonants++
      }
      else {
        count_other++
      }
    }
    printf("%d characters, %d vowels, %d consonants, %d other\n",length(str),count_vowels,count_consonants,count_other)
    exit(0)
}
