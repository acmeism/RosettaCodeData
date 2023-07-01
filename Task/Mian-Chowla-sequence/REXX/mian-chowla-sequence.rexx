/*REXX program computes and displays  any  range  of the  Mian─Chowla  integer sequence.*/
parse arg LO HI .                                /*obtain optional arguments from the CL*/
if LO=='' | LO==","  then LO=  1                 /*Not specified?  Then use the default.*/
if HI=='' | HI==","  then HI= 30                 /* "       "        "   "   "     "    */
r.= 0                                            /*initialize the rejects stemmed array.*/
#=  0                                            /*count of numbers in sequence (so far)*/
$=                                               /*the Mian─Chowla sequence  (so far).  */
   do t=1  until #=HI;      @.= r.0              /*process numbers until range is filled*/
     do i=1    for t;       if r.i  then iterate /*I  already rejected?  Then ignore it.*/
       do j=i  for t-i+1;   if r.j  then iterate /*J     "        "        "     "    " */
       _= i + j                                  /*calculate the sum of   I   and   J.  */
       if @._  then do;  r.t= 1; iterate t;  end /*reject  T  from Mian─Chowla sequence.*/
       @._= 1                                    /*mark  _  as one of the sequence sums.*/
       end   /*j*/
     end     /*i*/
   #= # + 1                                      /*bump the counter of terms in the list*/
   if #>=LO  then  if  #<=HI  then $= $ t        /*In the specified range?  Add to list.*/
   end       /*t*/
                                                 /*stick a fork in it,  we're all done. */
say 'The Mian─Chowla sequence for terms '      LO      "──►"       HI      ' (inclusive):'
say strip($)                                     /*ignore the leading superfluous blank.*/
