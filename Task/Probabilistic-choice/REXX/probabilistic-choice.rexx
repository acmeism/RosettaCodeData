/*REXX program displays results of probabilistic choices, gen random #s per probability.*/
parse arg trials digs seed .                     /*obtain the optional arguments from CL*/
if trials=='' | trials==","  then trials=1000000 /*Not specified?  Then use the default.*/
if   digs=='' |   digs==","  then   digs=15      /* "      "         "   "   "     "    */
if datatype(seed, 'W')  then call random ,,seed  /*allows repeatability for RANDOM nums.*/
numeric digits digs                              /*use a specific number of decimal digs*/
names= 'aleph beth gimel daleth he waw zayin heth ───totals───►'   /*names of the cells.*/
HI=100000                                                          /*max REXX RANDOM num*/
z=words(names);        #=z - 1                   /*#≡the number of actual/useable names.*/
$=0                                              /*initialize sum of the probabilities. */
           do n=1  for #;   prob.n=1 / (n+4);   if n==#  then prob.n= 1759 / 27720
           $=$ + prob.n;   Hprob.n=prob.n * HI
           end   /*n*/
prob.z=$                                         /*define the value of the ───totals───.*/
@.=0                                             /*initialize all counters in the range.*/
@.z=trials                                       /*define the last counter of  "    "   */
           do j=1  for trials;    r=random(HI)   /*gen  TRIAL  number of random numbers.*/
              do k=1  for #                      /*for each cell, compute  percentages. */
              if r<=Hprob.k  then @.k=@.k + 1    /* "    "    "  range, bump the counter*/
              end   /*k*/
           end      /*j*/
_= '═'                                           /*_:  a literal used for CENTER BIF pad*/
w=digs + 6                                       /*W:  display width for the percentages*/
d=4 + max( length(trials), length('count') )     /* [↓]  display a formatted top header.*/
say center('name',15,_)  center('count',d,_) center('target %',w,_) center('actual %',w,_)

     do cell=1  for z                            /*display each of the cells and totals.*/
     say  ' '   left( word(names, cell), 13)                    right(@.cell, d-2)  " ",
                left( format(   prob.cell   * 100, d),   w-2),
                left( format( @.cell/trials * 100, d),   w-2)
     if cell==#  then  say  center(_,15,_)   center(_,d,_)   center(_,w,_)   center(_,w,_)
     end   /*c*/                                 /* [↑]  display a formatted foot header*/
                                                 /*stick a fork in it,  we are all done.*/
