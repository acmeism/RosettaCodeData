/* call OPTMODEL procedure in SAS/OR */
proc optmodel;
   /* declare set and names of coins */
   set COINS = {1,5,10,25};
   str name {COINS} = ['penny','nickel','dime','quarter'];

   /* declare variables and constraint */
   var NumCoins {COINS} >= 0 integer;
   con Dollar:
      sum {i in COINS} i * NumCoins[i] = 100;

   /* call CLP solver */
   solve with CLP / findallsolns;

   /* write solutions to SAS data set */
   create data sols(drop=s) from [s]=(1.._NSOL_) {i in COINS} <col(name[i])=NumCoins[i].sol[s]>;
quit;

/* print all solutions */
proc print data=sols;
run;
