/*REXX program displays results of probabilistic choices, gen random #s per probability.*/
parse arg trials digs seed .                     /*obtain the optional arguments from CL*/
if trials=='' | trials==","  then trials=1000000 /*Not specified?  Then use the default.*/
if   digs=='' |   digs==","  then   digs=15      /* "      "         "   "   "     "    */
if datatype(seed, 'W')  then call random ,,seed  /*allows repeatability for RANDOM nums.*/
numeric digits digs                              /*use a specific number of decimal digs*/
names= 'aleph beth gimel daleth he waw zayin heth ───totals───►'       /*names of cells.*/
#= words(names) - 1;                                                          s=0
HI=100000
           do n=1  for #-1;     prob.n=1 / (n+4);    Hprob.n=prob.n * HI;     s=s + prob.n
           end   /*n*/
!.=0
prob.#=1759/27720;              !.9=trials;          Hprob.#=prob.# * HI;     s=s + prob.#
prob.9=s
           do j=1  for trials;  r=random(1, HI)  /*generate  X number of random numbers.*/
              do k=1  for #                      /*for each cell, compute  percentages. */
              if r<=Hprob.k  then !.k=!.k + 1    /* "    "    "  range, bump the counter*/
              end   /*k*/
           end      /*j*/
@= '═'                                           /*@:  a literal used for CENTER BIF pad*/
w=digs +6                                        /*W:  display width for the percentages*/
d=4 + max( length(trials), length('count') )     /* [↓]  display a formatted top header.*/
say center('name',15,@)  center('count',d,@) center('target %',w,@) center('actual %',w,@)

     do i=1  for #+1                             /*display each of the cells and totals.*/
     say  ' '   left( word(names, i), 13)                   right(!.i, d-2)  " ",
                left( format(   prob.i   * 100, d),   w-2),
                left( format( !.i/trials * 100, d),   w-2)
     if i==#  then  say  center(@,15,@)    center(@,d,@)    center(@,w,@)    center(@,w,@)
     end   /*i*/                                 /*stick a fork in it,  we are all done.*/
