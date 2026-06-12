/* create SAS data sets */
data cost_data;
   input from $ to $ cost;
   datalines;
s1 c1 3
s1 c2 5
s1 c3 7
s2 c1 3
s2 c2 2
s2 c3 5
;

data supply_data;
   input node $ supply;
   datalines;
s1  25
s2  35
c1 -20
c2 -30
c3 -10
;

/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare sets and parameters, and read input data */
   set <str,str> LINKS;
   num cost {LINKS};
   read data cost_data into LINKS=[from to] cost;
   set NODES = union {<i,j> in LINKS} {i,j};
   num supply {NODES} init 0;
   read data supply_data into [node] supply;
   num flow {LINKS};

   /* call network solver */
   solve with network /
      mincostflow links=(weight=cost) nodes=(weight=supply) direction=directed out=(flow=flow);

   /* print optimal solution */
   print _OROPTMODEL_NUM_['OBJECTIVE'];
   print flow;
quit;
