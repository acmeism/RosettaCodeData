HAI 2.3
HOW IZ I Init YR Stak
   Stak HAS A Length ITZ 0
IF U SAY SO

HOW IZ I Push YR Stak AN YR Value
  Stak HAS A SRS Stak'Z Length ITZ Value
  Stak'Z Length R SUM OF Stak'Z Length AN 1
IF U SAY SO

HOW IZ I Top YR Stak
  FOUND YR Stak'Z SRS DIFF OF Stak'Z Length AN 1
IF U SAY SO

HOW IZ I Pop YR Stak
  I HAS A Top ITZ I IZ Top YR Stak MKAY
  Stak'Z Length R DIFF OF Stak'Z Length AN 1
  FOUND YR Top
IF U SAY SO

HOW IZ I Empty YR Stak
  FOUND YR BOTH SAEM 0 AN Stak'Z Length
IF U SAY SO

I HAS A Stak ITZ A BUKKIT
I IZ Init YR Stak MKAY
I IZ Push YR Stak AN YR "Fred" MKAY
I IZ Push YR Stak AN YR "Wilma" MKAY
I IZ Push YR Stak AN YR "Betty" MKAY
I IZ Push YR Stak AN YR "Barney" MKAY

IM IN YR Loop UPPIN YR Dummy TIL I IZ Empty YR Stak MKAY
  VISIBLE I IZ Pop YR Stak MKAY
IM OUTTA YR Loop

KTHXBYE
