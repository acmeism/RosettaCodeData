/*REXX program shows how to  simultaneously  loop over
 multiple arrays.*/
x.=' ';      x.1="a";      x.2='b';      x.3="c";      x.4='d'
y.=' ';      y.1="A";      y.2='B';      y.3="C";
z.=' ';      z.1= 1 ;      z.2= 2 ;      z.3= 3 ;      z.4= 4;      z.5=
 5

       do j=1  until output=''
       output=x.j || y.j || z.j
       say output
       end   /*j*/                     /*stick a fork in it, we're
done.*/
