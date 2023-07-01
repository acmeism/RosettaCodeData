main:(
  printf(($gl$, ABS "a")); # for ASCII this prints "+97" EBCDIC prints "+129" #
  printf(($gl$, REPR 97))  # for ASCII this prints "a"; EBCDIC prints "/" #
)
