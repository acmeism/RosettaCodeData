/*REXX program displays results of probabilistic choices, gen random #s per probability.*/
Parse Arg trials digs seed .      /* obtain the optional arguments                    */
If trials==''|trials=="," Then    /* Not specified?                                   */
  trials=+1e6                     /* Use the default                                  */
If digs==''|digs=="," Then
  digs=15                         /* "      "         "   "   "                       */
If datatype(seed,'W') Then
  Call random,,seed               /* allows repeatability for RANDOM                  */
Numeric Digits digs               /* use a specific number of decima                  */
names='aleph beth gimel daleth he waw zayin heth Totals->',
/*names of the cells.*/
hi=100000                         /* max REXX RANDOM num                              */
z=words(names)
nn=z-1                            /* nn: the number of actual/usable cells            */
p=0                               /* initialize sum of the probabilities              */
Do n=1 To nn
  If n<nn Then
    prob.n=1/(n+4)                /* cell's probability                               */
  Else
    prob.n=1-p                    /* last cell's probability                          */
  p=p+prob.n
  hi.n=p*hi                       /* upper limit for cell n                           */
--say n prob.n hi.n
  End
  prob.9=1
cnt.=0
Do j=1 For trials
  r=random(hi)                    /* gen  TRIAL  number of random number              */
  Do k=1 to nn while r>hi.k       /* determine the cell number for r                  */
    End
  cnt.k+=1
  cnt.z+=1
  End

sep='-------- ----------- --------- ---------'
say 'Cell     Probability  Expected    Actual'
say sep
Do cell=1 For z
  Say left(word(names,cell),9),
      format(prob.cell*100,3,6),
      format(prob.cell*trials,9,0),
      format(cnt.cell,9,0)
  If cell==nn Then
    Say sep
  End
