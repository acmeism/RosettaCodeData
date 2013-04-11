$$ MODE TUSCRIPT
string="abcdefgh", n=4,m=n+2
substring=EXTRACT (string,#n,#m)
  PRINT substring
substring=Extract (string,#n,0)
  PRINT substring
substring=EXTRACT (string,0,-1)
  PRINT substring
n=SEARCH (string,":d:"),m=n+2
substring=EXTRACT (string,#n,#m)
  PRINT substring
substring=EXTRACT (string,":{substring}:"|,0)
  PRINT substring
