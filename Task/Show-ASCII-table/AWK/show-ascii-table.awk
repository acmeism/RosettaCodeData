# syntax: GAWK -f SHOW_ASCII_TABLE.AWK
# syntax: MAWK -f SHOW_ASCII_TABLE.AWK
BEGIN {
    for (i=0; i<16; i++) {
      for (j=32+i; j<128; j+=16) {
        if (j == 32) { x = "SPC" }
        else if (j == 127) { x = "DEL" }
        else { x = sprintf("%c",j) }
        printf("%3d: %-5s",j,x)
      }
      print ""
    }
}
