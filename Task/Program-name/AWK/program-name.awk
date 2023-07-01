# syntax: TAWK -f PROGRAM_NAME.AWK
#
# GAWK can provide the invoking program name from ARGV[0] but is unable to
# provide the AWK script name that follows -f.  Thompson Automation's TAWK
# version 5.0c, last released in 1998 and no longer commercially available, can
# provide the AWK script name that follows -f from the PROGFN built-in
# variable.  It should also provide the invoking program name, E.G. TAWK, from
# ARGV[0] but due to a bug it holds the fully qualified -f name instead.
#
# This example is posted here with hopes the TAWK built-in variables PROGFN
# (PROGram File Name) and PROGLN (PROGram Line Number) be added to GAWK by its
# developers.
#
BEGIN {
    printf("%s -f %s\n",ARGV[0],PROGFN)
    printf("line number %d\n",PROGLN)
    exit(0)
}
