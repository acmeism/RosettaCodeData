/*REXX program  generates and displays  three forms  of an   NxN   Pascal matrix.       */
numeric digits 50                                /*be able to calculate huge factorials.*/
parse arg N .                                    /*obtain the optional matrix  size (N).*/
if N==''  | N==","  then N= 5                    /*Not specified?  Then use the default.*/
                           call show N, Pmat(N, 'upper'), 'Pascal upper triangular matrix'
                           call show N, Pmat(N, 'lower'), 'Pascal lower triangular matrix'
                           call show N, Pmat(N, 'sym')  , 'Pascal symmetric matrix'
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
Pmat: procedure; parse arg N;    $=              /*generate a format of a Pascal matrix.*/
      arg , ?                                    /*get uppercase version of the 2nd arg.*/
              do i=0  for N; do j=0  for N       /*pick a format to use  [↓]            */
                             if abbrev('UPPER'      , ?, 1)  then $= $ comb(j  , i)
                             if abbrev('LOWER'      , ?, 1)  then $= $ comb(i  , j)
                             if abbrev('SYMMETRICAL', ?, 1)  then $= $ comb(i+j, j)
                             end  /*j*/         /*       ↑                              */
              end   /*i*/                       /*       │                              */
      return $                                  /*       └──min. abbreviation is 1 char.*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
!:    procedure; parse arg x;  !=1;    do j=2  to x;    != ! * j;    end;      return !
/*──────────────────────────────────────────────────────────────────────────────────────*/
comb: procedure; parse arg x,y;        if x=y  then return 1                /* {=} case.*/
                                       if y>x  then return 0                /* {>} case.*/
      if x-y<y  then y=x-y; _= 1;      do j=x-y+1  to x;  _= _ * j;  end;  return _ / !(y)
/*──────────────────────────────────────────────────────────────────────────────────────*/
show: procedure; parse arg s,@;   w=0;    #=0                               /*get args. */
                       do x=1  for s**2;  w=max(w,1+length(word(@,x)));  end
      say;   say center( arg(3), 50, '─')                                   /*show title*/
                       do   r=1  for s;   if r==1  then $= '[['             /*row  1    */
                                                   else $= ' ['             /*rows 2   N*/
                          do c=1  for s;  #= # + 1;     e= (c==s)           /*e ≡ "end".*/
                          $=$ || right( word(@, #), w) || left(', ',\e) || left("]", e)
                          end   /*c*/                                       /* [↑]  row.*/
                       say $ || left(',', r\==s)left(']', r==s)             /*show row. */
                       end     /*r*/
      return
