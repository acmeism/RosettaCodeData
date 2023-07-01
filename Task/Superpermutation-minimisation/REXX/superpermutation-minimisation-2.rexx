/*REXX program attempts  to find better  minimizations  for computing superpermutations.*/
parse arg cycles .                               /*obtain optional arguments from the CL*/
if cycles=='' | cycles==","  then cycles= 7      /*Not specified?  Then use the default.*/

      do n=0  to  cycles
      #= 0;                          $.=         /*populate the first permutation.      */
              do pop=1  for n;       @.pop= d2x(pop);         $.0= $.0  ||  @.pop
              end     /*pop*/

              do  while aPerm(n,0);  if n\==0  then #= #+1;   $.#=
                 do j=1  for n;      $.#= $.#  ||  @.j
                 end  /*j*/
              end     /*while*/
      z= $.0
                        c= 0                     /*count of found permutations (so far).*/
          do j=1  while c\==#
          if j>#  then do;  c= c + 1             /*exhausted finds and shortcuts; concat*/
                            z= z  ||  $.j;  $.j=
                            j= 1
                       end
          if $.j==''          then iterate       /*Already found? Then ignore this perm.*/
          if pos($.j, z)\==0  then do;  c= c + 1;      $.j=
                                        iterate
                                   end

              do k=n-1  to 1  by -1              /*handle the shortcuts in perm finding.*/
              if substr($.j, k)==left(z, k)  then do;  c= c+1  /*found rightish shortcut*/
                                                       z= left($.j, k-1)  ||  z;     $.j=
                                                       iterate j
                                                  end
              if left($.j, k) ==right(z, k)  then do;  c= c+1 /*found   leftish shortcut*/
                                                       z= z  ||  substr($.j, k+1);   $.j=
                                                       iterate j
                                                  end
              end   /*k*/                        /* [↑]  more IFs could be added for opt*/
           end      /*j*/

       L= commas( length(z) )
       say 'length of superpermutation('n") ="     right(L, max(length(L), cycles+2) )
       end   /*n*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
commas: parse arg ?;  do jc=length(?)-3  to 1  by -3; ?=insert(',', ?, jc); end;  return ?
/*──────────────────────────────────────────────────────────────────────────────────────*/
aPerm: procedure expose @.;     parse arg n,i;    nm=n-1;  if n==0  then return 0
           do k=nm  by -1  for nm; kp=k+1; if @.k<@.kp  then do; i=k;leave; end; end /*k*/
           do j=i+1  while  j<n;  parse value  @.j @.n  with  @.n @.j;    n=n-1; end /*j*/
       if i==0  then return 0
           do m=i+1  while @.m<@.i; end /*m*/;   parse value  @.m @.i  with  @.i @.m
       return 1
