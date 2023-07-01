/* create SAS data set */
data mydata;
   input item $1-23 weight value pieces;
   datalines;
map                      9  150  1
compass                 13   35  1
water                  153  200  2
sandwich                50   60  2
glucose                 15   60  2
tin                     68   45  3
banana                  27   60  3
apple                   39   40  3
cheese                  23   30  1
beer                    52   10  3
suntan cream            11   70  1
camera                  32   30  1
T-shirt                 24   15  2
trousers                48   10  2
umbrella                73   40  1
waterproof trousers     42   70  1
waterproof overclothes  43   75  1
note-case               22   80  1
sunglasses               7   20  1
towel                   18   12  2
socks                    4   50  1
book                    30   10  2
;

/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare sets and parameters, and read input data */
   set <str> ITEMS;
   num weight {ITEMS};
   num value {ITEMS};
   num pieces {ITEMS};
   read data mydata into ITEMS=[item] weight value pieces;

   /* declare variables, objective, and constraints */
   var NumSelected {i in ITEMS} >= 0 <= pieces[i] integer;
   max TotalValue = sum {i in ITEMS} value[i] * NumSelected[i];
   con WeightCon:
      sum {i in ITEMS} weight[i] * NumSelected[i] <= 400;

   /* call mixed integer linear programming (MILP) solver */
   solve;

   /* print optimal solution */
   print TotalValue;
   print {i in ITEMS: NumSelected[i].sol > 0.5} NumSelected;
quit;
