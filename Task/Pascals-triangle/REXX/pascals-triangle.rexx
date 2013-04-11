/*REXX program to display Pascal's triangle,  neatly centered/formatted.*/
/*AKA:   Yang Hui's ▲,   Khayyam-Pascal ▲,   Kyayyam ▲,   Tartaglia's ▲ */
numeric digits 1000                    /*let's be able to handle big ▲. */
arg nn .;   if nn==''  then nn=10;     n=abs(nn)
a. = 1                                 /*if NN < 0, output is to a file.*/
mx = !(n-1) / !(n%2) / !(n-1-n%2)      /*MX =biggest number in triangle.*/
w = length(mx)                         /* W =width of biggest number.   */
line. = 1

  do row=1  for n;    prev=row-1
  a.row.1 = 1
                      do j=2  to row-1;     jm=j-1
                      a.row.j = a.prev.jm + a.prev.j
                      line.row = line.row   right(a.row.j,w)
                      end   /*j*/

  if row\==1  then line.row=line.row right(1,w)   /*append the last "1".*/
  end    /*row*/

width=length(line.n)                   /*width of last line in triangle.*/

        do L=1  for n                  /*show lines in Pascal's triangle*/
        if nn>0 then say center(line.L,width)     /*either SAY or write.*/
                else call  lineout  'PASCALS.'n, center(line.L,width)
        end   /*L*/
exit                                   /*stick a fork in it, we're done.*/
/*─────────────────────────────────────! (factorial) subroutine─────────*/
!: procedure; arg x;!=1;do j=2 to x;!=!*j;end;return ! /*calc. factorial*/
