# syntax: GAWK -f GENERIC_SWAP.AWK
BEGIN {
    printf("%s version %s\n",ARGV[0],PROCINFO["version"])
    foo = 1
    bar = "a"
    printf("\n%s %s\n",foo,bar)
    rc = swap("foo","bar") # ok
    printf("%s %s %s\n",foo,bar,rc?"ok":"ng")
    printf("\n%s %s\n",foo,bar)
    rc = swap("FOO","BAR") # ng
    printf("%s %s %s\n",foo,bar,rc?"ok":"ng")
    exit(0)
}
function swap(a1,a2,  tmp) { # strings or numbers only; no arrays
    if (a1 in SYMTAB && a2 in SYMTAB) {
      if (isarray(SYMTAB[a1]) || isarray(SYMTAB[a2])) {
        return(0)
      }
      tmp = SYMTAB[a1]
      SYMTAB[a1] = SYMTAB[a2]
      SYMTAB[a2] = tmp
      return(1)
    }
    return(0)
}
