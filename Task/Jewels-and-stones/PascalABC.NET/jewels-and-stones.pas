// Jewels and stones. Nigel Galloway: September 27th., 2024
##
var fN:string->string->integer:=jewels->stones->stones.Aggregate(0,(n,g)->n+if jewels.Contains(g) then 1 else 0);
fN('aA')('aAAbbbb').println;
