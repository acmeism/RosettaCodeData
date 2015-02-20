/*REXX pgm gens some random #s, shows bin histogram, finds mean & stdDev*/
numeric digits 20                      /*use twenty digits precision,   */
showDigs=digits()%2                    /*  ··· but only show ten digits.*/
parse arg size seed .                  /*allow specification: size, seed*/
if size=='' | size==','  then size=100 /*if not specified, then use 100.*/
if datatype(seed,'W')    then call random ,,seed  /*allow seed for RAND.*/
#.=0                                   /*count of numbers in each bin.  */
                do j=1  for size       /*generate some random numbers.  */
                @.j=random(0,99999)/100000      /*express as a fraction.*/
                _=substr(@.j'00',3,1)  /*determine which bin it's in,   */
                #._=#._+1              /*    ···  and bump its count.   */
                end   /*j*/

        do k=0  for 10                 /*show a histogram of the bins.  */
        lr='0.'k      ;  if k==0  then lr='0  '  /*adjust for low range.*/
        hr='0.'||(k+1);  if k==9  then hr='1  '  /*   "    " high range.*/
        range=lr"──►"hr' '                       /*construct the range. */
        barPC=right(strip(left(format(100*#.k/size,,2),5)),5)   /*comp %*/
        say range barPC copies('─',format(barPC*1,,0))          /*histo.*/
        end   /*k*/
say
say 'sample size = ' size;   say
avg=mean(size)     ;         say '       mean = ' format(avg,,showDigs)
stddev=stddev(size);         say '     stddev = ' format(stddev,,showDigs)
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────MEAN subroutine─────────────────────*/
mean:   parse arg N .; $=0;   do m=1  for N;  $=$+@.m;           end /*m*/
return $/n
/*──────────────────────────────────STDDEV subroutine───────────────────*/
stddev: parse arg N .; $=0;   do s=1  for N;  $=$+(@.s-avg)**2;  end /*s*/
return sqrt($/n)
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt:   procedure; parse arg x;   if x=0  then return 0; d=digits()
numeric digits 11; numeric form;  m.=11;  p=d+d%4+2
parse value format(x,2,1,,0) 'E0' with g 'E' _ .;        g=g*.5'E'_%2
 do j=0  while p>9;   m.j=p;   p=p%2+1;  end
 do k=j+5 to 0 by -1; if m.k>11 then numeric digits m.k; g=.5*(g+x/g); end
numeric digits d;  return g/1
