/*REXX program computes    pi ÷ 4   using the  Monte Carlo  algorithm.        */
parse arg times chunks .               /*does user want a specific number?    */
if  times==''  then  times=1000000000  /*one billion should do it, me thinks. */
if chunks==''  then chunks=10000       /*do Monte Carlo in  10,000  chunks.   */
limit=10000-1                          /*REXX random generates only integers. */
limitSq=limit**2                       /*··· so, instead of one, use limit**2.*/
!=0                                    /*the number of  "pi hits"   (so far). */
accur=0                                /*accuracy of Monte Carlo pi (so far). */
if 1=='f1'x  then piChar='pi'          /*if  EBCDIC,  then use  literal.      */
             else piChar='e3'x         /* "   ASCII,    "   "   pi glyph,     */

pi=3.14159265358979323846264338327950288419716939937511  /*this, da real McCoy*/
numeric digits length(pi)              /*this program uses these decimal digs.*/
say 'real pi='pi"+"                    /*we might as well brag about it.      */
say                                    /*a blank line, just for the eyeballs. */
        do j=1  for times%chunks
          do chunks                    /*do Monte Carlo,  one chunk-at-a-time.*/
          if random(0,limit)**2 + random(0,limit)**2 <=limitSq  then !=!+1
          end   /*chunks*/
        reps=chunks*j                  /*compute the number of repetitions.   */
        piX=4*!/reps                   /*let's see how this puppy does so far.*/
        _=compare(piX,pi)              /*compare apples and  ···  crabapples. */
        if _<=accur  then iterate      /*if not better accuracy,  keep going. */
        say right(commas(reps),20)   'repetitions:  Monte Carlo'   piChar,
            "is accurate to" _-1 'places.'   /*subtract one for decimal point.*/
        accur=_                        /*use this accuracy for the baseline.  */
        end   /*j*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
commas: procedure;  parse arg _;   n=_'.9';    #=123456789;    b=verify(n,#,"M")
        e=verify(n,#'0',,verify(n,#"0.",'M'))-4
           do j=e  to b  by -3;   _=insert(',',_,j);    end  /*j*/;     return _
