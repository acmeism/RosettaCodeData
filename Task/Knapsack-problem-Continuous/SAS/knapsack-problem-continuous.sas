/* create SAS data set */
data mydata;
   input item $ weight value;
   datalines;
beef    3.8  36
pork    5.4  43
ham     3.6  90
greaves 2.4  45
flitch  4.0  30
brawn   2.5  56
welt    3.7  67
salami  3.0  95
sausage 5.9  98
;

/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare sets and parameters, and read input data */
   set <str> ITEMS;
   num weight {ITEMS};
   num value {ITEMS};
   read data mydata into ITEMS=[item] weight value;

   /* declare variables, objective, and constraints */
   var WeightSelected {i in ITEMS} >= 0 <= weight[i];
   max TotalValue = sum {i in ITEMS} (value[i]/weight[i]) * WeightSelected[i];
   con WeightCon:
      sum {i in ITEMS} WeightSelected[i] <= 15;

   /* call linear programming (LP) solver */
   solve;

   /* print optimal solution */
   print TotalValue;
   print {i in ITEMS: WeightSelected[i].sol > 1e-3} WeightSelected;
quit;
