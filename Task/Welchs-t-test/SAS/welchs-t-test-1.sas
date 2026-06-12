data tbl;
input value group @@;
cards;
3 1 4 1 1 1 2.1 1 490.2 2 340 2 433.9 2
;
run;

proc ttest data=tbl;
class group;
var value;
run;
