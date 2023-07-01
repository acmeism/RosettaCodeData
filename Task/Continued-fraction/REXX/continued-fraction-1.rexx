/*REXX program  calculates and displays  values of  various  continued fractions.       */
parse arg terms digs .
if terms=='' | terms==","  then terms=500
if  digs=='' |  digs==","  then  digs=100
numeric digits digs                              /*use  100  decimal digits for display.*/
b.=1                                             /*omitted ß terms are assumed to be  1.*/
/*══════════════════════════════════════════════════════════════════════════════════════*/
a.=2;                                                           call tell '√2',      cf(1)
/*══════════════════════════════════════════════════════════════════════════════════════*/
a.=1;  do N=2  by  2  to terms; a.N=2; end;                     call tell '√3',      cf(1)     /*also:  2∙sin(π/3) */
/*══════════════════════════════════════════════════════════════════════════════════════*/
a.=2                  /*              ___ */
      do N=2  to 17   /*generalized  √ N  */
      b.=N-1;                          NN=right(N, 2);          call tell 'gen √'NN, cf(1)
      end   /*N*/
/*══════════════════════════════════════════════════════════════════════════════════════*/
a.=2;   b.=-1/2;                                                call tell 'gen √ ½', cf(1)
/*══════════════════════════════════════════════════════════════════════════════════════*/
  do j=1 for terms; a.j=j;  if j>1   then b.j=a.p; p=j; end;    call tell 'e',       cf(2)
/*══════════════════════════════════════════════════════════════════════════════════════*/
a.=1;                                                           call tell 'φ, phi',  cf(1)
/*══════════════════════════════════════════════════════════════════════════════════════*/
a.=1;    do j=1 for terms;  if j//2  then a.j=j;        end;    call tell 'tan(1)',  cf(1)
/*══════════════════════════════════════════════════════════════════════════════════════*/
         do j=1 for terms;                a.j=2*j+1;    end;    call tell 'coth(1)', cf(1)
/*══════════════════════════════════════════════════════════════════════════════════════*/
         do j=1 for terms;                a.j=4*j+2;    end;    call tell 'coth(½)', cf(2)    /*also:  [e+1]÷[e-1] */
/*══════════════════════════════════════════════════════════════════════════════════════*/
                     terms=100000
a.=6;    do j=1  for terms;  b.j=(2*j-1)**2;            end;    call tell 'π, pi',   cf(3)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cf:      procedure expose a. b. terms;  parse arg C;     !=0;    numeric digits 9+digits()
                                          do k=terms  by -1  for terms;  d=a.k+!;  !=b.k/d
                                          end   /*k*/
         return !+C
/*──────────────────────────────────────────────────────────────────────────────────────*/
tell:    parse arg ?,v;   $=left(format(v)/1,1+digits());    w=50    /*50 bytes of terms*/
         aT=;     do k=1;  _=space(aT a.k);  if length(_)>w  then leave;  aT=_;  end /*k*/
         bT=;     do k=1;  _=space(bT b.k);  if length(_)>w  then leave;  bT=_;  end /*k*/
                          say right(?,8)   "="    $     '  α terms='aT  ...
         if b.1\==1  then say right("",12+digits())     '  ß terms='bT  ...
         a=;   b.=1;  return       /*only 50 bytes of  α & ß terms  ↑   are displayed.  */
