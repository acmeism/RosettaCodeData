/*REXX program solves the  Sum and Product Puzzle (also known as the Impossible Puzzle).*/
@.= 0;                        h= 100;  @.3= 1    /*assign array default;  assign high P.*/
             do j=5  by 2  to h                  /*find all odd primes  ≤  1st argument.*/
               do k=3  while k*k<=j;   if j//k==0  then iterate j          /*J ÷ by K ? */
               end  /*k*/;             @.j= 1    /*found a net prime number: J          */
             end    /*j*/
@.2=1                                            /*assign the even prime, ex post facto.*/
     do s=2  for h-1;  if C1(s)==0  then iterate /*find and display the puzzle solution.*/
     $= 0;                do m=2  for  s%2 -1    /* [↓]  check for uniqueness of product*/
                          if C2(m * (s-m))  then do;  if $>0  then iterate s;  $= m;   end
                          end   /*m*/
     if $>0  then say  'The numbers are:  '         $            " and "           s-$
     end   /*s*/
if $==0  then     say  'No solution found.'
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
C1: procedure expose @.;        parse arg s      /*validate the first puzzle condition. */
      do a=2  for s%2-1;        if @.a  then do;   _= s - a;   if @._  then return 0;  end
      end;  /*a*/;              return 1
/*──────────────────────────────────────────────────────────────────────────────────────*/
C2: procedure expose @. h;  parse arg p;    $= 0 /*validate the second puzzle condition.*/
      do j=2  while j*j<p                        /*perform up to the square root of  P. */
      if p//j==0  then do;               q= p % j
                       if q>=2  then  if q<=h  then  if C1(j+q)  then  if $  then return 0
                                                                             else $= 1
                       end
      end   /*j*/;              return $
