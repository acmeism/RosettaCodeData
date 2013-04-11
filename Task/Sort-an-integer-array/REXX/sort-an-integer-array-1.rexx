/*REXX program to sort  (E-sort)  an array   (which contains integers). */
                           numeric digits 30    /*handle larger numbers.*/
 a.1=               1
 a.2=               0
 a.3=              -1
 a.4=               0
 a.5=               5
 a.6=               0
 a.7=             -61
 a.8=               0
 a.9=            1385
a.10=               0
a.11=          -50521
a.12=               0
a.13=         2702765
a.14=               0
a.15=      -199360981
a.16=               0
a.17=     19391512145
a.18=               0
a.19=  -2404879675441
a.20=               0
a.21= 370371188237525

size=21                                /*have a list of 21 Euler numbers*/
call tell 'un-sorted'
call esort size
call tell '   sorted'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────ESORT subroutine────────────────────*/
esort: procedure expose a.;   parse arg N;   h=N
        do while h>1;       h=h%2
          do i=1 for N-h;   j=i;   k=h+i
              do while a.k<a.j
              parse value a.j a.k with a.k a.j      /*swap two elements.*/
              if h>=j then leave;  j=j-h;  k=k-h
              end   /*while a.k<a.j*/
          end       /*i*/
        end         /*while h>1*/
return
/*──────────────────────────────────TELL subroutine─────────────────────*/
tell: say center(arg(1),50,'─')
         do j=1 for size
         say arg(1) 'array element' right(j,length(size))'='right(a.j,20)
         end   /*j*/
say
return
