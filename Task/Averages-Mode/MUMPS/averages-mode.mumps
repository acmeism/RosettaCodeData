MODE(X)
 ;X is assumed to be a list of numbers separated by "^"
 ;I is a loop index
 ;L is the length of X
 ;Y is a new array
 ;ML is the list of modes
 ;LOC is a placeholder to shorten the statement
 Q:'$DATA(X) "No data"
 Q:X="" "Empty Set"
 NEW Y,I,L,LOC
 SET L=$LENGTH(X,"^"),ML=""
 FOR I=1:1:L SET LOC=+$P(X,"^",I),Y(LOC)=$S($DATA(Y(LOC)):Y(LOC)+1,1:1)
 SET I="",I=$O(Y(I)),ML=I ;Prime the pump, rather than test for no data
 FOR  S I=$O(Y(I)) Q:I=""  S ML=$SELECT(Y($P(ML,"^"))>Y(I):ML,Y($P(ML,"^"))<Y(I):I,Y($P(ML,"^"))=Y(I):ML_"^"_I)
 QUIT ML
