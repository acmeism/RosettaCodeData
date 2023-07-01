/*REXX program attempts  to find better  minimizations  for computing superpermutations.*/
parse arg cycles .                               /*obtain optional arguments from the CL*/
if cycles=='' | cycles==","  then cycles= 7      /*Not specified?  Then use the default.*/

      do n=0  to  cycles
      #= 0;                           $.=        /*populate the first permutation.      */
              do pop=1  for n;        @.pop= d2x(pop);        $.0= $.0  ||  @.pop
              end  /*pop*/

              do  while aPerm(n, 0)
              if n\==0  then #= #+1;  $.#=
                do j=1  for n;        $.#= $.#  ||  @.j
                end   /*j*/
              end     /*while*/
      z= $.0
      nm= n-1
              do p=1  for #;      if $.j==''          then iterate
                                  if pos($.p, z)\==0  then iterate
              parse  var   $.p    h  2  R  1  L  =(n)
              if  left(z, nm)==R  then do;    z= h  ||  z;    iterate;   end
              if right(z,  1)==h  then do;    z= z  ||  R;    iterate;   end
              z= z  ||  $.p
              end   /*p*/                        /* [↑]  more IFs could be added for opt*/

       L= commas( length(z) )
       say 'length of superpermutation('n") ="      right(L, max(length(L), cycles+2) )
       end   /*cycle*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
aPerm: procedure expose @.;    parse arg n,i;      nm= n - 1;      if n==0  then return 0
          do k=nm  by -1  for nm; kp=k+1; if @.k<@.kp  then do; i=k; leave; end; end /*k*/
          do j=i+1  while  j<n;  parse value  @.j @.n  with  @.n @.j;    n= n-1; end /*j*/
       if i==0  then return 0
          do m=i+1  while @.m<@.i; end /*m*/;    parse value  @.m  @.i   with   @.i  @.m
       return 1
