/*REXX program  finds  (and maybe displays)  Smith  (or joke)  numbers up to a given  N.*/
parse arg N .                                    /*obtain optional argument from the CL.*/
if N=='' | N==","  then N=10000                  /*Not specified?  Then use the default.*/
tell= (N>0);            N=abs(N) - 1             /*use the  │N│  for computing  (below).*/
#=0                                              /*the number of Smith numbers (so far).*/
w=length(N)                                      /*W:  used for aligning Smith numbers. */
@=;    do j=4  for  max(0, N-3)                  /*process almost all numbers up to  N. */
       if sumD(j) \== sumFactr(j)  then iterate  /*Not a Smith number?   Then ignore it.*/
       #=#+1                                     /*bump the Smith number counter.       */
       if \tell  then iterate                    /*Not showing the numbers? Keep looking*/
       @=@ right(j, w);        if length(@)>199 then do;   say substr(@, 2);    @=;    end
       end   /*j*/                               /* [↑]  if N>0,  then display Smith #s.*/

if @\==''  then say substr(@, 2)                 /*if any residual Smith #s, display 'em*/
say                                              /* [↓]  display the number of Smith #s.*/
say #   ' Smith numbers found  ≤ '  max(0,N)"."  /*display number of Smith numbers found*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
sumD:     parse arg x 1 s 2;   do d=2  for length(x)-1; s=s+substr(x,d,1); end;   return s
/*──────────────────────────────────────────────────────────────────────────────────────*/
sumFactr: procedure;  parse arg z;      $=0;   f=0           /*obtain  Z  number (arg1).*/
             do  while z// 2==0; $=$+ 2; f=f+1; z=z% 2;  end /*maybe add factor of   2. */
             do  while z// 3==0; $=$+ 3; f=f+1; z=z% 3;  end /*  "    "     "    "   3. */
             do  while z// 5==0; $=$+ 5; f=f+1; z=z% 5;  end /*  "    "     "    "   5. */
             do  while z// 7==0; $=$+ 7; f=f+1; z=z% 7;  end /*  "    "     "    "   7. */
          t=z;  r=0;  q=1;       do while q<=t; q=q*4;   end /*R:  will be the iSqrt(Z).*/
             do while q>1;  q=q%4;  _=t-r-q;  r=r%2;  if _>=0  then do;  t=_;  r=r+q;  end
             end   /*while q>1*/                             /* [↑] compute int. SQRT(Z)*/

             do j=11  by 6  to r  while j<=z                 /*skip factors that are ÷ 3*/
             parse var  j  ''  -1  _;     if _\==5 then,     /*is last dec. digit ¬a 5 ?*/
               do  while z//j==0; f=f+1; $=$+sumD(j); z=z%j; end   /*maybe reduce Z by J*/
             if _==3  then iterate;      y=j+2
               do  while z//y==0; f=f+1; $=$+sumD(y); z=z%y; end   /*maybe reduce Z by Y*/
             end   /*j*/                                     /* [↓]  Z  is what's left. */
          if z\==1  then do;      f=f+1; $=$+sumD(z);  end   /*if a residual, then add Z*/
          if f<2    then return 0                            /*Is prime? It's not Smith#*/
                         return $                            /*else, return sum of digs.*/
