STRCASE(S)
 SET UP="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
 SET LO="abcdefghijklmnopqrstuvwxyz"
 WRITE !,"Given: "_S
 WRITE !,"Upper: "_$TRANSLATE(S,LO,UP)
 WRITE !,"Lower: "_$TRANSLATE(S,UP,LO)
 QUIT
