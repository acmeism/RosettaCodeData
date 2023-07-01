/* build a dataset */
data test;
do i=1 to 10000;
	x=rannor(12345);
	output;
end;
keep x;
run;

/* compute the five numbers */
proc means data=test min p25 median p75 max;
var x;
run;
