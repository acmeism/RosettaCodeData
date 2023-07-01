$$ MODE DATA

$$ BUILD X_TABLE soundex = *
:b:1:f:1:p:1:v:1:
:c:2:g:2:j:2:k:2:1:2:s:2:x:2:z:2:
:d:3:t:3:
:l:4:
:m:5:n:5:
:r:6:

$$ names="Christiansen'Kris Jenson'soundex'Lloyd'Woolcock'Donnell'Baragwanath'Williams'Ashcroft'Euler'Ellery'Gauss'Ghosh'Hilbert'Heilbronn'Knuth'Kant'Ladd'Lukasiewicz'Lissajous'Wheaton'Burroughs'Burrows"

$$ MODE TUSCRIPT,{}
LOOP/CLEAR n=names
 first=EXTRACT (n,1,2),second=EXTRACT (n,2,3)
 IF (first==second) THEN
  rest=EXTRACT (n,3,0)
 ELSE
  rest=EXTRACT (n,2,0)
 ENDIF

 soundex=EXCHANGE (rest,soundex)
 soundex=STRINGS  (soundex,":{\0}:a:e:i:o:u:")
 soundex=REDUCE   (soundex)
 soundex=STRINGS  (soundex,":{\0}:",0,0,1,0,"")
 soundex=CONCAT   (soundex,"000")
 soundex=EXTRACT  (soundex,0,4)

 PRINT first,soundex,"=",n
ENDLOOP
