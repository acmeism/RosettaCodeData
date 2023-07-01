/*REXX pgm filters a signal with a order3 lowpass Butterworth, direct form II transposed*/
@a= '1           -2.77555756e-16  3.33333333e-1  -1.85037171e-17'  /*filter coefficients*/
@b=  0.16666667   0.5             0.5             0.16666667       /*  "          "     */
@s= '-0.917843918645  0.141984778794   1.20536903482    0.190286794412  -0.662370894973' ,
    '-1.00700480494  -0.404707073677   0.800482325044   0.743500089861   1.01090520172 ' ,
    ' 0.741527555207  0.277841675195   0.400833448236  -0.2085993586    -0.172842103641' ,
    '-0.134316096293  0.0259303398477  0.490105989562   0.549391221511   0.9047198589  '
$.=0;            N=words(@s);    w=length(n);   numeric digits 24  /* [↑]  signal vector*/
     do i=1  for N;              #=0           /*process each of the vector elements. */
       do j=1  for words(@b); if i-j >= 0  then #= # + word(@b, j) * word(@s, i-j+1);  end
       do k=1  for words(@a); _= i -k +1;  if i-k >= 0  then #= # - word(@a, k) * $._; end
     $.i= # / word(@a ,1);         call tell
     end   /*i*/                                 /* [↑]  only show using ½ the dec. digs*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell: numeric digits digits()%2;  say right(i, w)   " "   left('', $.i>=0)$.i /1;   return
