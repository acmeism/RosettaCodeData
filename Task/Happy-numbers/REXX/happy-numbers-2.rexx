/*REXX program displays  eight (or a specified range of) happy  numbers.*/
parse arg L H .                        /*get optional args:  low & high */
if L=='' | L==',' then L=8             /*Not specified? Set L to default*/
if H=='' | H==',' then do; H=L; L=1; end  /*use a range for the showing.*/
#.0=0; #.1=1; #.2=4; #.3=9; #.4=16; #.5=25; #.6=36; #.7=49; #.8=64; #.9=81
haps=0                                 /*count of happy numbers so far. */
@.=0;     !.=0                         /*sparse array: happy&unhappy #s.*/

  do n=1  while haps<H;   q=n;  a.=0   /*search integers starting at  1.*/
  if !.n  then iterate                 /*if  N  is unhappy, try another.*/

    do  until q==1                     /*see if  Q  is a happy number.  */
    s=0                                /*prepare to add squares of digs.*/
            do j=1  for length(q)      /*sum the squares of the digits. */
            _=substr(q,j,1)            /*get a single digit (in base 10)*/
            s=s+#._                    /*add the square  of  a  digit.  */
            end   /*j*/

    if @.s  then do; q=1; iterate; end /*we have found a  happy  number.*/
    if !.s  then iterate n             /*Sum unhappy?  Then Q is unhappy*/
    if a.s  then do                    /*If already summed? Q is unhappy*/
                 !.q=1;   !.s=1        /*mark  Q & S  as unhappy numbers*/
                 iterate n             /*previously summed, so Q unhappy*/
                 end
    a.s=1;  q=s                        /*mark sum as found, try  Q  sum.*/
    end      /*until*/

  @.n=1                                /*mark   N  as a happy number.   */
  haps=haps+1                          /*bump the count of happy numbers*/
  if haps<L  then iterate              /*don't display,  N  is too low. */
  say n                                /*display the  happy  N   number.*/
  end        /*n*/
                                       /*stick a fork in it, we're done.*/
