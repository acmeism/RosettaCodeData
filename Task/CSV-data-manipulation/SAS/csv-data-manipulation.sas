data _null_;
infile datalines dlm="," firstobs=2;
file "output.csv" dlm=",";
input c1-c5;
if _n_=1 then put "C1,C2,C3,C4,C5,Sum";
s=sum(of c1-c5);
put c1-c5 s;
datalines;
C1,C2,C3,C4,C5
1,5,9,13,17
2,6,10,14,18
3,7,11,15,19
4,8,12,16,20
;
run;
