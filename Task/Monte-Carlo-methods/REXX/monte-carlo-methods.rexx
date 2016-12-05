/*REXX program computes and displays the value of  pi÷4  using the Monte Carlo algorithm*/
pi=3.141592653589793238462643383279502884197169399375105820974944592307816406 /*true pi.*/
say '                  1         2         3         4         5         6         7   '
say 'scale:  1·234567890123456789012345678901234567890123456789012345678901234567890123'
say                                              /* [↑]  a two-line scale for showing pi*/
say 'true pi='pi"+"                              /*we might as well brag about true  pi.*/
numeric digits length(pi) - 1                    /*this program uses these decimal digs.*/
parse arg times chunk .                          /*does user want a specific number?    */
if times=='' | times==","  then times=1000000000 /*one billion should do it, hopefully. */
if chunk=='' | chunk=="."  then chunk=     10000 /*perform  Monte Carlo in  10k  chunks.*/
limit=10000-1                                    /*REXX random generates only integers. */
limitSq=limit**2                                 /*··· so, instead of one, use limit**2.*/
accur=0                                          /*accuracy of Monte Carlo pi (so far). */
!=0;  @reps='repetitions:  Monte Carlo  pi  is'  /*pi  decimal digit accuracy  (so far).*/
say                                              /*a blank line,  just for the eyeballs.*/
      do j=1  for times%chunk
                          do chunk               /*do Monte Carlo,  one chunk at-a-time.*/
                          if random(0,limit)**2 + random(0,limit)**2 <=limitSq  then !=!+1
                          end   /*chunk*/
      reps=chunk*j                               /*calculate the number of repetitions. */
      _=compare(4*! / reps, pi)                  /*compare apples and  ···  crabapples. */
      if _<=accur  then iterate                  /*if not better accuracy, keep trukin'.*/
      say right(commas(reps),20) @reps 'accurate to'  _-1  "places."   /*-1 for dec. pt.*/
      accur=_                                    /*use this accuracy for next baseline. */
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;        n=_'.9';        #=123456789;     b=verify(n,#,"M")
                    e=verify(n, #'0', , verify(n, #"0.", 'M') ) - 4
                       do j=e  to b  by -3;   _=insert(',',_,j);   end  /*j*/;    return _
