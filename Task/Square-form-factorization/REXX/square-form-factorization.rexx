/*REXX pgm factors an integer using Daniel Shanks' (1917-1996) square form factorization*/
numeric digits 100                                       /*ensure enough decimal digits.*/
call dMults 1,3,5,7,11,3*5,3*7,3*11,5*7,5*11,7*11, 3*5*7, 3*5*11, 3*7*11, 5*7*11, 3*5*7*11
call dTests 2501,  12851,  13289,  75301,  120787,  967009, 997417,  7091569,  13290059, ,
            42854447,  223553581,  2027651281, 11111111111, 100895598169, 1002742628021, ,
            60012462237239,   287129523414791,    9007199254740931,   11111111111111111, ,
            314159265358979323,    384307168202281507,    419244183493398773,            ,
            658812288346769681,    922337203685477563,    1000000000000000127,           ,
            1152921505680588799,   1537228672809128917,   4611686018427387877
                            w= length( commas(!.$) )     /*the max width of test numbers*/
      do tests=1  for !.0;  n= !.tests;  nc= commas(n)
      f= ssff(n);   fc= commas(f);     wf= length(fc);     if f\==0  then nf= commas(n%f)
      if f\==0  then do;  nfc= commas(n%f);      wnfc= length(nfc);   end
      if f ==0  then _= "   (Shank's square form factor failed.)"
                else _= ' factors are: '  right( fc, max(w%2  , wf  ) )     "  and  "   ,
                                          right(nfc, max(w%2+4, wnfc) )
      say right(nc, w+5)   _
      end   /*tests*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
dMults: @.$= 0;  do j=1  for arg(); @.j= arg(j); @.$=max(@.$, @.j); end; @.0=j-1; return
dTests: !.$= 0;  do j=1  for arg(); !.j= arg(j); !.$=max(!.$, !.j); end; !.0=j-1; return
gcd:    procedure; parse arg x,y;  do until _==0;  _= x // y;  x= y;   y= _; end; return x
/*──────────────────────────────────────────────────────────────────────────────────────*/
iSqrt: procedure; parse arg x;  r=0;  q=1;             do while q<=x;  q=q*4;  end
                  do while q>1; q=q%4; _=x-r-q; r=r%2; if _>=0 then do;x=_;r=r+q; end; end
       return r
/*──────────────────────────────────────────────────────────────────────────────────────*/
ssff:  procedure expose @.;  parse arg n;   n= abs(n);               er= '***error***'
       s= iSqrt(n);          if s**2==n  then return s;              big= 2**digits()
               do #=1  for @.0;   k= @.#          /*get a # from the list of low factors*/
               if n>big/k  then do; say er 'number is too large: '  commas(k); exit 8; end
               d= n*k;      po= iSqrt(d);   p= po
               pprev= po;   QQ= d - po*po
               qprev= 1;    BB= iSqrt(s+s)*6
                                                  do i=2  while i<BB;         b= (po+p)%QQ
                                                  p= b*QQ - p;                q= QQ
                                                  QQ= qprev + b*(pprev-p);    r= iSqrt(QQ)
                                                  if i//2==0  then  if r*r==QQ  then leave
                                                  qprev= q;                   pprev= p
                                                  end   /*i*/
               if i>=BB  then iterate
               b= (po-p)%r;   p= b*r + p
               pprev= p;             qprev= r
               QQ= (d - pprev*pprev)%qprev
                                                  do until p==pprev;          pprev= p
                                                  b= (po+p)%QQ;     q= QQ;    p= b*QQ - p
                                                  QQ= qprev + b*(pprev-p);    qprev= q
                                                  end   /*until*/
               r= gcd(n, qprev)
               if r\==1  then if  r\==n  then return r
               end   /*#*/
       return 0
