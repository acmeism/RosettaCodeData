# syntax: GAWK -f STRIP_BLOCK_COMMENTS.AWK filename
# source: https://www.gnu.org/software/gawk/manual/gawk.html#Plain-Getline
# Remove text between /* and */, inclusive
{   while ((start = index($0,"/*")) != 0) {
      out = substr($0,1,start-1) # leading part of the string
      rest = substr($0,start+2) # ... */ ...
      while ((end = index(rest,"*/")) == 0) { # is */ in trailing part?
        if (getline <= 0) { # get more text
          printf("unexpected EOF or error: %s\n",ERRNO) >"/dev/stderr"
          exit
        }
        rest = rest $0 # build up the line using string concatenation
      }
      rest = substr(rest,end+2) # remove comment
      $0 = out rest # build up the output line using string concatenation
    }
    printf("%s\n",$0)
}
END {
    exit(0)
}
