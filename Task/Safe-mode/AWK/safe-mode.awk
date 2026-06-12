# syntax: GAWK --sandbox -f SAFE_MODE.AWK
#
# Per The GNU Awk User’s Guide, edition 4.2.1
# https://www.gnu.org/software/gawk/manual/gawk.html
#   --sandbox or -S
#   Disable the system() function, input redirections with getline, output
#   redirections with print and printf, and dynamic extensions.  This is
#   particularly useful when you want to run awk scripts from questionable
#   sources and need to make sure the scripts can't access your system (other
#   than the specified input data file).
#
# Error message when running in sandbox mode:
# gawk: SAFE_MODE.AWK:16: fatal: redirection not allowed in sandbox mode
#
BEGIN {
    print("hello world") >"A.TMP"
    exit(0)
}
