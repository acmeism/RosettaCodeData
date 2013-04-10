/*REXX program to compute 10!*/  say '10! =' !(10); exit

!: procedure;  !=1;  do j=2 to arg(1);  !=!*j;  end;  return !
