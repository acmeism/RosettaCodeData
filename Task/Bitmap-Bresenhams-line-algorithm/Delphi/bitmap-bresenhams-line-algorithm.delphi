procedure drawLine (bitmap : TBitmap; xStart, yStart, xEnd, yEnd : integer; color : TAlphaColor);
// Bresenham's Line Algorithm.  Byte, March 1988, pp. 249-253.
// Modified from http://www.efg2.com/Lab/Library/Delphi/Graphics/Bresenham.txt and tested.
var
      a, b       :  integer;  // displacements in x and y
      d          :  integer;  // decision variable
      diag_inc   :  integer;  // d's increment for diagonal steps
      dx_diag    :  integer;  // diagonal x step for next pixel
      dx_nondiag :  integer;  // nondiagonal x step for next pixel
      dy_diag    :  integer;  // diagonal y step for next pixel
      dy_nondiag :  integer;  // nondiagonal y step for next pixel
      i          :  integer;  // loop index
      nondiag_inc:  integer;  // d's increment for nondiagonal steps
      swap       :  integer;  // temporary variable for swap
      x,y        :  integer;  // current x and y coordinates
begin
    x := xStart;              // line starting point}
    y := yStart;
    // Determine drawing direction and step to the next pixel.
    a := xEnd - xStart;       // difference in x dimension
    b := yEnd - yStart;       // difference in y dimension
    // Determine whether end point lies to right or left of start point.
    if a < 0 then             // drawing towards smaller x values?
       begin
       a := -a;               // make 'a' positive
       dx_diag := -1
       end
    else
       dx_diag := 1;

    // Determine whether end point lies above or below start point.
    if b < 0 then             // drawing towards smaller x values?
       begin
       b := -b;               // make 'a' positive
       dy_diag := -1
       end
    else
       dy_diag := 1;
    // Identify octant containing end point.
    if a < b then
       begin
       swap := a;
       a := b;
       b := swap;
       dx_nondiag := 0;
       dy_nondiag := dy_diag
       end
    else
       begin
       dx_nondiag := dx_diag;
       dy_nondiag := 0
       end;
    d := b + b - a;           // initial value for d is 2*b - a
    nondiag_inc := b + b;     // set initial d increment values
    diag_inc    := b + b - a - a;
    for i := 0 to a do
        begin   /// draw the a+1 pixels
        drawPixel (bitmap, x, y, color);
        if d < 0 then            // is midpoint above the line?
           begin                 // step nondiagonally
           x := x + dx_nondiag;
           y := y + dy_nondiag;
           d := d + nondiag_inc  // update decision variable
           end
        else
           begin                 // midpoint is above the line; step diagonally}
           x := x + dx_diag;
           y := y + dy_diag;
           d := d + diag_inc
           end;
    end;
end;
