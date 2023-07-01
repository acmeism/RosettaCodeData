/* REXX ***************************************************************
* 21.05.2014  Walter Pachl
* Implementing the pseudo code of
*    http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
* under 'Simplification'
**********************************************************************/
grid.='.'
Do i=-2 To  7; grid.i.0='-'; End
Do j=-4 To 11; grid.0.j='|'; End
grid.0.0='+'
Call line -1,-3,6,10
Do j=11 To -4 By -1
  ol=format(j,2)' '
  Do i=-2 To 7
    ol=ol||grid.i.j
    End
  Say ol
  End
Say '   2101234567'
Exit
line: Procedure Expose grid.
Parse Arg x0, y0, x1, y1
dx = abs(x1-x0)
dy = abs(y1-y0)
if x0 < x1 then sx = 1
           else sx = -1
if y0 < y1 then sy = 1
           else sy = -1
err = dx-dy

Do Forever
  grid.x0.y0='X'
  if x0 = x1 & y0 = y1 Then Leave
  e2 = 2*err
  if e2 > -dy then do
    err = err - dy
    x0 = x0 + sx
    end
  if e2 < dx then do
    err = err + dx
    y0 = y0 + sy
    end
  end
Return
