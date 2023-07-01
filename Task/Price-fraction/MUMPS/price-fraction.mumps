PRICFRAC(X)
 ;Outputs a specified value dependent upon the input value
 ;The non-inclusive upper limits are encoded in the PFMAX string, and the values
 ;to convert to are encoded in the PFRES string.
 NEW PFMAX,PFRES,I,RESULT
 SET PFMAX=".06^.11^.16^.21^.26^.31^.36^.41^.46^.51^.56^.61^.66^.71^.76^.81^.86^.91^.96^1.01"
 SET PFRES=".10^.18^.26^.32^.38^.44^.50^.54^.58^.62^.66^.70^.74^.78^.82^.86^.90^.94^.98^1.00"
 Q:(X<0)!(X>1.01) ""
 FOR I=1:1:$LENGTH(PFMAX,"^") Q:($DATA(RESULT)'=0)  SET:X<$P(PFMAX,"^",I) RESULT=$P(PFRES,"^",I)
 KILL PFMAX,PFRES,I
 QUIT RESULT
