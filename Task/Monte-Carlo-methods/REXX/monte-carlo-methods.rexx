/*REXX program uses the  Monte Carlo  method to  compute    pi÷4        */
parse arg times chunks .               /*does user want a specific num? */
if  times=='' then  times=1000000000   /*one billion should do it.      */
if chunks=='' then chunks=10000        /*do Monte Carle in 10k chunks.  */
limit=10000-1                          /*REXX random gens only integers.*/
limitSq=limit**2                       /*...so, instead of 1, use lim**2*/
!=0                                    /*number of  "pi hits"  so far.  */
accur=0                                /*accuracy of the Monte Carlo pi.*/
if 1=='f1'x then piChar='pi'           /*if EBCDIC, then use literal.   */
            else piChar='e3'x          /*if  ASCII, then use symbol.    */

pi=3.14159265358979323846264338327950288419716939937511  /*da real McCoy*/
numeric digits length(pi)              /*at least, we'll use these digs.*/
say 'real pi='pi"+"                    /*might was well brag about it.  */
say                                    /*just for the eyeballs.         */
        do j=1 for times%chunks
            do chunks                  /*do Monte Carlo, chunk-at-a-time*/
            if random(0,limit)**2+random(0,limit)**2<=limitSq then !=!+1
            end
        reps=chunks*j                  /*compute number of repetitions. */
        piX=4*!/reps                   /*let's see how this puppy does. */
        _=compare(piX,pi)              /*compare apples & ...crabapples.*/
        if _<=accur then iterate       /*if not better accuracy,  pout. */
        say right(comma(reps),20) 'repetitions:  Monte Carlo' piChar,
            "is accurate to" _-1 'places.'   /*subtract 1 for dec point.*/
        accur=_                        /*use this accuracy for baseline.*/
        end     /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*────────────────────────────────COMMA subroutine──────────────────────*/
comma:  procedure;   parse arg _,c,p,t;  arg ,cu;  c=word(c ",",1)
if cu=='BLANK' then c=' ';  o=word(p 3,1); p=abs(o); t=word(t 999999999,1)
if \datatype(p,'W') | \datatype(t,'W')|p==0|arg()>4 then return _; n=_'.9'
#=123456789; k=0;  if o<0 then  do; b=verify(_,' '); if b==0 then return _
e=length(_) - verify(reverse(_),' ') + 1; end;  else do; b=verify(n,#,"M")
e=verify(n,#'0',,verify(n,#"0.",'M'))-p-1;  end
do j=e  to b  by -p  while k<t;  _=insert(c,_,j);  k=k+1;  end;   return _
