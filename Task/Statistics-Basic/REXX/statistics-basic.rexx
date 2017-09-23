/*REXX program generates some random numbers, shows bin histogram, finds mean & stdDev. */
numeric digits 20                                /*use twenty decimal digits precision, */
showDigs=digits()%2                              /* ··· but only show ten decimal digits*/
parse arg size seed .                            /*allow specification:  size, and seed.*/
if size=='' | size==","  then size=100           /*Not specified?  Then use the default.*/
if datatype(seed,'W')    then call random ,,seed /*allow a  seed  for the  RANDOM  BIF. */
#.=0                                             /*count of the numbers in each bin.    */
                do j=1  for size                 /*generate some random numbers.        */
                @.j=random(0, 99999) / 100000    /*express random number as a fraction. */
                _=substr(@.j'00', 3, 1)          /*determine which bin the number is in,*/
                #._=#._+1                        /*    ···  and bump its count.         */
                end   /*j*/

        do k=0  for 10;  kp=k+1                  /*show a histogram of the bins.        */
        lr='0.'k      ;  if k==0  then lr="0  "  /*adjust for the  low range.           */
        hr='0.'kp     ;  if k==9  then hr="1  "  /*   "    "   "  high range.           */
        barPC=right(strip(left(format(100*#.k/size, , 2), 5)) ,5)    /*compute the  %.  */
        say lr"──►"hr' '  barPC copies('─', format(barPC*1, , 0))    /*display histogram*/
        end   /*k*/
say
say 'sample size = ' size;          say
avg=  mean(size)         ;          say '       mean = '           format(avg, , showDigs)
std=stdDev(size)         ;          say '     stdDev = '           format(std, , showDigs)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
mean:   parse arg N; $=0;    do m=1 for N; $=$+@.m;          end;         return $/n
stdDev: parse arg N; $=0;    do s=1 for N; $=$+(@.s-avg)**2; end;         return sqrt($/n)
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits;  parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;  g=g*.5'e'_ % 2
                  do j=0  while h>9;       m.j=h;                h=h%2+1;        end /*j*/
                  do k=j+5  to 0  by -1;   numeric digits m.k;   g=(g+x/g)*.5;   end /*k*/
      return g/1
