/*REXX program computes and displays the value of  pi÷4  using the Monte Carlo algorithm*/
/*true pi*/ pi=3.141592653589793238462643383279502884197169399375105820974944592307816406
say '                    1         2         3         4         5         6         7   '
say 'scale:    1·234567890123456789012345678901234567890123456789012345678901234567890123'
say                                              /* [↑]  a two-line scale for showing pi*/
say 'true pi= '       pi"+"                      /*we might as well brag about true  pi.*/
numeric digits length(pi) - 1                    /*this program uses these decimal digs.*/
parse arg times chunk .                          /*does user want a specific number?    */
if times=='' | times==","  then times=5e12       /*five trillion should do it, hopefully*/
if chunk=='' | chunk=="."  then chunk=100000     /*perform Monte Carlo in  100k  chunks.*/
limit=10000 - 1                                  /*REXX random generates only integers. */
limitSq=limit**2                                 /*··· so, instead of one, use limit**2.*/
accuracy=0                                       /*accuracy of Monte Carlo pi  (so far).*/
!=0;  @reps= 'repetitions:  Monte Carlo  pi  is' /*pi  decimal digit accuracy  (so far).*/
say                                              /*a blank line,  just for the eyeballs.*/
      do j=1  for times % chunk
                       do chunk                  /*do Monte Carlo,  one chunk at-a-time.*/
                       if random(, limit)**2 + random(, limit)**2 <= limitSq  then !=! + 1
                       end   /*chunk*/
      reps=chunk * j                             /*calculate the number of repetitions. */
      _=compare(4*! / reps, pi)                  /*compare apples and  ···  crabapples. */
      if _<=accuracy  then iterate               /*Not better accuracy?  Keep truckin'. */
      say right(comma(reps), 20) @reps  'accurate to'  _-1  "places."  /*─1 ≡ dec. point*/
      accuracy=_                                 /*use this accuracy for next baseline. */
      end   /*j*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
comma: procedure; arg _;  do k=length(_)-3  to 1  by -3; _=insert(',',_,k); end;  return _
