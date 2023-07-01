/* create SAS data set */
data mydata;
   input Item $1-19 Value weight Volume;
   datalines;
panacea (vials of) 3000 0.3 0.025
ichor (ampules of) 1800 0.2 0.015
gold (bars)        2500 2.0 0.002
;

/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare sets and parameters, and read input data */
   set <str> ITEMS;
   num value {ITEMS};
   num weight {ITEMS};
   num volume {ITEMS};
   read data mydata into ITEMS=[item] value weight volume;

   /* declare variables, objective, and constraints */
   var NumSelected {ITEMS} >= 0 integer;
   max TotalValue = sum {i in ITEMS} value[i] * NumSelected[i];
   con WeightCon:
      sum {i in ITEMS} weight[i] * NumSelected[i] <= 25;
   con VolumeCon:
      sum {i in ITEMS} volume[i] * NumSelected[i] <= 0.25;

   /* call mixed integer linear programming (MILP) solver */
   solve;

   /* print optimal solution */
   print TotalValue;
   print NumSelected;

   /* to get all optimal solutions, call CLP solver instead */
   solve with CLP / findallsolns;

   /* print all optimal solutions */
   print TotalValue;
   for {s in 1.._NSOL_} print {i in ITEMS} NumSelected[i].sol[s];
quit;
