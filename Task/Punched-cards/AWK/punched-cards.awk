# syntax: GAWK -f PUNCHED_CARDS.AWK [-v debug=x]
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    debug += 0 # 0=none, 1=show mapping, 2=show all characters, 3=blank card, 4=lace card
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    hollerith_mapping()
    if (debug ~ /3/) {
      print("A 'blank card' has no holes punched. See https://en.wikipedia.org/wiki/Punched_card#/media/File:Unused_punch_card_from_UIC.jpg")
      blank_card()
    }
    if (debug ~ /4/) {
      print("A 'lace card' has all holes punched. See https://en.wikipedia.org/wiki/Lace_card")
      main(strdup("\xFF",80))
    }
    main("&-0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZ abcdefghijklmnopqrstuvwxyz")
    main("Hello world!  RosettaCode.ORG  !#$%&'()*+,-./:;<=>?@[ ]^_`{|}~\"\\")
    exit(errors == 0 ? 0 : 1)
}
function main(str,  arr,c,col,hole,i,nrows,row,rows) {
    hole = "X" # character to indicate hole
    nrows = split("12,11,0,1,2,3,4,5,6,7,8,9",rows,",")
    if (length(str) > 80) {
      error("truncated to 80 columns")
      str = substr(str,1,80)
    }
# put holes in 80-column card
    for (col=1; col<=80; col++) {
      c = substr(str,col,1)
      if (c in HHarr) {
      # hole = c # un-comment to use actual character for the hole
        for (i=1; i<=length(HHarr[c]); i++) {
          row = substr(HHarr[c],i,1)
          if (row == "T") { arr[12][col] = hole }
          else if (row == "E") { arr[11][col] = hole }
          else { arr[row][col] = hole }
        }
      }
      else if (c != "") {
        error(sprintf("character %1s in column %d is invalid",c,col))
      }
    }
# print 80-column card
    printf(" /%s+\n",strdup("-",79)) # top of card
    printf("/%-80s|\n",str)
    for (i=1; i<=nrows; i++) { # rows 12, 11, 0..9
      row = rows[i]
      printf("|")
      for (col=1; col<=80; col++) {
        printf("%1s",arr[row][col])
      }
      printf("|%s\n",row) # right of card
    }
    printf("+%s+\n",strdup("-",80)) # bottom of card
    printf(ruler(80," ")) # under card
    printf("\n")
}
function hollerith_mapping(  arr,i,s) {
#
# each Hollerith code is separated by a space
# position 1 is the ASCII character
# position 2 up to the space may contain:
#   T   : row 12, I.E. 12-punch
#   E   : row 11, I.E. 11-punch
#   0-9 : rows 0 through 9
#
    s=s"00 11 22 33 44 55 66 77 88 99 "       # 0-9
    s=s"AT1 BT2 CT3 DT4 ET5 FT6 GT7 HT8 IT9 " # A-I
    s=s"JE1 KE2 LE3 ME4 NE5 OE6 PE7 QE8 RE9 " # J-R
    s=s"S02 T03 U04 V05 W06 X07 Y08 Z09 "     # S-Z
    s=s"aT01 bT02 cT03 dT04 eT05 fT06 gT07 hT08 iT09 " # a-i
    s=s"jTE1 kTE2 lTE3 mTE4 nTE5 oTE6 pTE7 qTE8 rTE9 " # j-r
    s=s"sE02 tE03 uE04 vE05 wE06 xE07 yE08 zE09 "      # s-z
    s=s"!T78 \"78 #38 $E38 %048 &T '58 (T58 )E58 *E48 +T68 ,038 -E .T38 /01 " # other characters
    s=s":28 ;E68 <T48 =68 >068 ?078 "
    s=s"@48 [T28 \\028 ]E28 ^E78 _058 `18 {T0 |TE }E0 ~E01 "
    s=s"\xFFTE0123456789 " # X'FF' is all holes punched
    split(s,arr," ")
    for (i in arr) {
      if (substr(arr[i],2) !~ /^T?E?[0-9]*$/) {
        error(sprintf("%s is invalid",arr[i]))
      }
      HHarr[substr(arr[i],1,1)] = substr(arr[i],2)
    }
    HHarr[" "] = " " # a space has no holes punched
    for (i=0; i<=255; i++) { ord_arr[sprintf("%c",i)] = i } # build array[character]=ordinal_value
    if (debug ~ /1/) { # show mapping
      printf("Hollerith codes: %d\n",length(HHarr))
      print("hex   = char = mapping  T=row 12, E=row 11, 0-9=rows 0..9")
      for (i in HHarr) { printf("X'%02X' = %-4s = %s\n",ord_arr[i],i,HHarr[i]) }
    }
    if (debug ~ /2/) { # show all characters
      printf("\nAll characters\n")
      s = ""
      for (i in HHarr) { s = s i }
      while (s != "") {
        main(substr(s,1,80))
        s = substr(s,81)
      }
    }
}
function blank_card(  row) {
    printf(" /%s+\n",strdup("-",79)) # top of card
    printf("/%80s|\n","")
    printf("|%80s|12\n","")
    printf("|%80s|11\n","")
    for (row=0; row<=9; row++) {
      printf("|%80s|%s\n",strdup(row,80),row)
    }
    printf("+%s+\n",strdup("-",80)) # bottom of card
    printf(ruler(80," ")) # under card
    printf("\n")
}
function error(message) { printf("error: %s\n",message) ; errors++ }
function ruler(width,prefix,suffix,  fmt,i,j,line,str,x) {
    fmt = sprintf("%%0%sd",length(width)) # build %0?d format string
    for (i=1; i<=width; i++) {         # build column heading lines
      x = sprintf(fmt,i)
      for (j=1; j<=length(x); j++) {
        line[j] = line[j] substr(x,j,1)
      }
    }
    for (i=1; i<=length(width); i++) { # write column headings
      str = str sprintf("%s%s%s\n",prefix,line[i],suffix)
    }
    return(str)
}
function strdup(str,n,  i,new_str) {
    for (i=1; i<=n; i++) {
      new_str = new_str str
    }
    return(new_str)
}
