/* create SAS data set */
data Edges;
   input Start $ End $ Cost;
   datalines;
a  b  7
a  c  9
a  f  14
b  c  10
b  d  15
c  d  11
c  f  2
d  e  6
e  f  9
;

/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare sets and parameters, and read input data */
   set <str,str> LINKS;
   num cost {LINKS};
   read data Edges into LINKS=[start end] cost;
   set NODES = union {<i,j> in LINKS} {i,j};
   set SOURCES = {'a'};
   set SINKS = {'e'};
   /* <source,sink,order,from,to> */
   set <str,str,num,str,str> PATHS;

   /* call network solver */
   solve with network /
      shortpath=(source=SOURCES sink=SINKS) links=(weight=cost) out=(sppaths=PATHS);

   /* write shortest path to SAS data set */
   create data path from [source sink order from to]=PATHS cost[from,to];
quit;

/* print shortest path */
proc print data=path;
run;
