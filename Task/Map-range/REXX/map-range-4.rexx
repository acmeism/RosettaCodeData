/*REXX program maps a number from one range to another range.           */
/* 31.10.2013 Walter Pachl   */
/*                  'translated' from an older version 1 without using Procedure */
  do j=0  to 10
    say right(j,3)   ' maps to '   mapRange(0,10,-1,0,j)
    end
exit
/*──────────────────────────────────MAPRANGE subroutine─────────────────*/
mapRange: return arg(3)+(arg(5)-arg(1))*(arg(4)-arg(3))/(arg(2)-arg(1))
/* Arguments are arg a1,a2,b1,b2,x */
