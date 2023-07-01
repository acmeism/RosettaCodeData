/* create SAS data set */
data mydata;
   input item $1-23 weight value;
   datalines;
map                      9  150
compass                 13   35
water                  153  200
sandwich                50  160
glucose                 15   60
tin                     68   45
banana                  27   60
apple                   39   40
cheese                  23   30
beer                    52   10
suntan cream            11   70
camera                  32   30
T-shirt                 24   15
trousers                48   10
umbrella                73   40
waterproof trousers     42   70
waterproof overclothes  43   75
note-case               22   80
sunglasses               7   20
towel                   18   12
socks                    4   50
book                    30   10
;

/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare sets and parameters, and read input data */
   set <str> ITEMS;
   num weight {ITEMS};
   num value {ITEMS};
   read data mydata into ITEMS=[item] weight value;

   /* declare variables, objective, and constraints */
   var NumSelected {ITEMS} binary;
   max TotalValue = sum {i in ITEMS} value[i] * NumSelected[i];
   con WeightCon:
      sum {i in ITEMS} weight[i] * NumSelected[i] <= 400;

   /* call mixed integer linear programming (MILP) solver */
   solve;

   /* print optimal solution */
   print TotalValue;
   print {i in ITEMS: NumSelected[i].sol > 0.5} NumSelected;
quit;
