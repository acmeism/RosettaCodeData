# usage:  gawk -f sfcopy.awk input.txt

BEGIN {
    print "# Selective File Copy:"
}

{
  # print NR ": <" $0 ">"  ## debug: print input

    F1 = substr($0,  1,5)
    F2 = substr($0, 11,4)
    F3 = substr($0, 15,1)
    if(F3=="-") {F2 = 0-F2}
    F9 = "xxxxx"

    printf("%-5s%5d%s\n", F1, F2, F9)
}

END {
    print "# Done."
}
