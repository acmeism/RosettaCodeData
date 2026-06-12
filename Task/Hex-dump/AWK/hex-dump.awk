# syntax: GAWK -f HEX_DUMP.AWK [-v FB=x] [-v LB=x] filename
#
# example: GAWK -f HEX_DUMP.AWK HEX_DUMP.TXT
#
# HEX_DUMP.TXT contains "Rosetta Code is a programming chrestomathy site."
#
# AWK does not support Unicode so ASCII is used.  See GAWK 5.3
# reference manual, section 11.2.7.1, Modern Character Sets.
#
# I have chosen to show the byte number in decimal rather than
# hexadecimal.  When employed I had requests to dump the first 1000
# bytes of a file; never the first 3E8 bytes.  That being said, you
# are free to change "%08d" to "%08X".
#
BEGIN {
    if (ARGC-1 == 0) { error("no files") }
    if (FB == "") { FB = 1 }
    if (LB == "") { LB = 99999999 }
    if (!(FB ~ /^[0-9]+$/ && FB > 0)) { error("FirstByte is invalid") }
    if (!(LB ~ /^[0-9]+$/ && LB > 0)) { error("LastByte is invalid") }
    if (FB > LB) { error("FirstByte > LastByte") }
    if (errors > 0) {
      exit # go to END
    }
    print("  byte    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F         ASCII")
    print("-------- ----------------------- -----------------------    ----------------")
    for (i=0; i<=255; i++) { ord_arr[sprintf("%c",i)] = i } # build array[character]=ordinal_value
    BINMODE = 1
    RS = "\x1A\x1A" # Record Separator that will most likely not appear in file
}                   # allows file to be read as one chunk
{   str = (FNR == 1) ? $0 : (RS $0) # prepend RS for 2nd ... nth records
    for (i=1; i<=length(str); i++) {
      byte_nbr++
      if (byte_nbr < FB || byte_nbr > LB) {
        continue
      }
      if (++printed % 16 == 1) {
        printf("%08d ",byte_nbr)
      }
      c = substr(str,i,1)
      printf("%02X ",ord_arr[c])
      c16 = (c ~ /[\x00-\x1F\x7F-\xFF]/) ? (c16 ".") : (c16 c) # unprintable or printable
      if (length(c16) == 16) {
        printf(" | %16s |\n",c16)
        c16 = ""
      }
    }
}
END {
    if (errors > 0) {
      exit(1)
    }
    if (length(c16) > 0) {
      printf("%*s | %-16s |\n",(16-length(c16))*3,"",c16)
    }
    printf("%08d bytes\n",printed)
    exit(0)
}
function error(message) { printf("error: %s\n",message) ; errors++ }
