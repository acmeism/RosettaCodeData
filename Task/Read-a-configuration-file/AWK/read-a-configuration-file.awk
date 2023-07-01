# syntax: GAWK -f READ_A_CONFIGURATION_FILE.AWK
BEGIN {
    fullname = favouritefruit = ""
    needspeeling = seedsremoved = "false"
    fn = "READ_A_CONFIGURATION_FILE.INI"
    while (getline rec <fn > 0) {
      tmp = tolower(rec)
      if (tmp ~ /^ *fullname/) { fullname = extract(rec) }
      else if (tmp ~ /^ *favouritefruit/) { favouritefruit = extract(rec) }
      else if (tmp ~ /^ *needspeeling/) { needspeeling = "true" }
      else if (tmp ~ /^ *seedsremoved/) { seedsremoved = "true" }
      else if (tmp ~ /^ *otherfamily/) { split(extract(rec),otherfamily,",") }
    }
    close(fn)
    printf("fullname=%s\n",fullname)
    printf("favouritefruit=%s\n",favouritefruit)
    printf("needspeeling=%s\n",needspeeling)
    printf("seedsremoved=%s\n",seedsremoved)
    for (i=1; i<=length(otherfamily); i++) {
      sub(/^ +/,"",otherfamily[i]) # remove leading spaces
      sub(/ +$/,"",otherfamily[i]) # remove trailing spaces
      printf("otherfamily(%d)=%s\n",i,otherfamily[i])
    }
    exit(0)
}
function extract(rec,  pos,str) {
    sub(/^ +/,"",rec)       # remove leading spaces before parameter name
    pos = match(rec,/[= ]/) # determine where data begins
    str = substr(rec,pos)   # extract the data
    gsub(/^[= ]+/,"",str)   # remove leading "=" and spaces
    sub(/ +$/,"",str)       # remove trailing spaces
    return(str)
}
