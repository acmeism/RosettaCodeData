# syntax: GAWK -f SEND_MORE_MONEY.AWK
# converted from FreeBASIC
BEGIN {
    m = 1
    for (s=8; s<=9; s++) {
      for (e=0; e<=9; e++) {
        if (e != m && e != s) {
          for (n=0; n<=9; n++) {
            if (n != m && n != s && n != e) {
              for (d=0; d<=9; d++) {
                if (d != m && d != s && d != e && d != n) {
                  for (o=0; o<=9; o++) {
                    if (o != m && o != s && o != e && o != n && o != d) {
                      for (r=0; r<=9; r++) {
                        if (r != m && r != s && r != e && r != n && r != d && r != o) {
                          for (y=0; y<=9; y++) {
                            if (y != m && y != s && y != e && y != n && y != d && y != o) {
                              if (1000*(s+m)+100*(e+o)+10*(n+r)+d+e == 10000*m+1000*o+100*n+10*e+y) {
                                print("send+more=money")
                                print(s e n d "+" m o r e "=" m o n e y)
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    exit(0)
}
