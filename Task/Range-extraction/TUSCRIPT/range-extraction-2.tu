$$ MODE TUSCRIPT
MODE DATA
$$ numbers=*
0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
37, 38, 39
$$ MODE TUSCRIPT
numbers=EXCHANGE (numbers,":,><<> :':")
unrangednrs=JOIN (numbers,"")

help = APPEND (unrangednrs, "999999999")
rest = REMOVE (help, 1, n_1)
n_2 = n_1, n_3= n_2 + 1,rangednrs= ""
LOOP n= rest
 IF (n!=n_3)  THEN
    rangednrs = APPEND (rangednrs, n_1)
    IF (n_1!=n_2) THEN
    range=n_1+1
      IF (range==n_2) THEN
      rangednrs = APPEND (rangednrs,n_2)
      ELSE
      rangednrs = CONCAT (rangednrs, "-", n_2)
      ENDIF
    ENDIF
    n_1 = n
 ENDIF
 n_2 = n, n_3 = n_2 + 1
ENDLOOP
rangednrs=EXCHANGE (rangednrs,":':,:")
PRINT rangednrs
