# syntax: GAWK -f OLD_LADY_SWALLOWED_A_FLY.AWK
BEGIN {
    arr[++i] = "fly/"
    arr[++i] = "spider/That wriggled and jiggled and tickled inside her"
    arr[++i] = "bird/Quite absurd@"
    arr[++i] = "cat/Fancy that@"
    arr[++i] = "dog/What a hog@"
    arr[++i] = "pig/Her mouth was so big@"
    arr[++i] = "goat/Opened her throat and down went the goat"
    arr[++i] = "cow/I don't know how@"
    arr[++i] = "donkey/It was rather wonkey@"
    arr[++i] = "horse/She's dead of course"
    leng = i # array length
    for (i=1; i<=leng; i++) {
      s = arr[i]
      A[i] = substr(s,1,index(s,"/")-1) # critter name
      text = substr(s,index(s,"/")+1)
      sub(/@/," to swallow a "A[i],text)
      printf("I know an old lady who swallowed a %s.\n",A[i])
      if (text != "") {
        printf("%s.\n",text)
      }
      if (i == leng) {
        break
      }
      for (j=i; j>1; j--) {
        printf("She swallowed the %s to catch the %s.\n",A[j],A[j-1])
      }
      printf("I don't know why she swallowed the fly.\n")
      printf("Perhaps she'll die.\n\n")
    }
    exit(0)
}
