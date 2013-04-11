/*REXX program sorts a  (stemmed) array  using the  merge-sort  method. */
call gen@                              /*generate the array elements.   */
call show@ 'before sort'               /*show the before array elements.*/
call mergeSort highItem                /*invoke the merge sort for array*/
call show@ ' after sort'               /*show the  after array elements.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GEN@ subroutine─────────────────────*/
gen@:   @.=                            /*assign default value for @ stem*/
@.1='---The seven deadly sins---'      /*everybody:  pick your favorite.*/
@.2='==========================='
@.3='pride'
@.4='avarice'
@.5='wrath'
@.6='envy'
@.7='gluttony'
@.8='sloth'
@.9='lust'
           do highItem=1 while @.highItem\==''  /*find number of entries*/
           end
highItem=highItem-1                             /*adjust highItem by -1.*/
return
/*──────────────────────────────────MERGETO@ subroutine─────────────────*/
mergeTo@: procedure expose @. !.;  parse arg L,n; if n==1 then return
if n==2 then do;              h=L+1
             if @.L>@.h  then do;   _=@.h;   @.h=@.L;   @.L=_;   end
             return
             end
m=n%2
call mergeTo@ L+m,n-m
call mergeTo! L,m,1
i=1;   j=L+m;         do k=L  while k<j
                      if j==L+n | !.i<=@.j  then do;  @.k=!.i;  i=i+1; end
                                            else do;  @.k=@.j;  j=j+1; end
                      end   /*k*/
return
/*──────────────────────────────────MERGESORT subroutine────────────────*/
mergeSort:  procedure expose @.;    call mergeTo@ 1,arg(1)
return
/*──────────────────────────────────MERGETO! subroutine─────────────────*/
mergeTo!:   procedure expose @. !.;     parse arg L,n,_
if n==1 then do;   !._=@.L;   return;   end
if n==2 then do
             h=L+1;      q=1+_
             if @.L>@.h  then     do;   q=_;   _=q+1;   end
             !._=@.L;    !.q=@.h
             return
             end
m=n%2
call mergeTo@ L,m
call mergeTo! L+m,n-m,m+_
i=L;   j=m+_
                   do k=_  while k<j
                   if j==n+_ | @.i<=!.j   then do;  !.k=@.i;  i=i+1;  end
                                          else do;  !.k=!.j;  j=j+1;  end
                   end   /*k*/
return
/*──────────────────────────────────SHOW@ subroutine────────────────────*/
show@: widthH=length(highItem)         /*maximum the width of any line. */
                      do j=1 for highItem
                      say 'element' right(j,widthH) arg(1)':' @.j
                      end   /*j*/
say copies('─',60)                     /*show a seperator line (fence). */
return
