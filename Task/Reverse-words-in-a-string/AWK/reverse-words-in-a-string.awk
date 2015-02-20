# syntax: GAWK -f REVERSE_WORDS_IN_A_STRING.AWK
BEGIN {
    text[++i] = "---------- Ice and Fire ------------"
    text[++i] = ""
    text[++i] = "fire, in end will world the say Some"
    text[++i] = "ice. in say Some"
    text[++i] = "desire of tasted I've what From"
    text[++i] = "fire. favor who those with hold I"
    text[++i] = ""
    text[++i] = "... elided paragraph last ..."
    text[++i] = ""
    text[++i] = "Frost Robert -----------------------"
    leng = i
    for (i=1; i<=leng; i++) {
      n = split(text[i],arr," ")
      for (j=n; j>0; j--) {
        printf("%s ",arr[j])
      }
      printf("\n")
    }
    exit(0)
}
