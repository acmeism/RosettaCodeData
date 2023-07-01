begin % draw an Archimedian spiral %
      % Translation of AWK which was a trnslation of Applesoft Basic program %
    integer procedure max ( integer x, y ) ; begin if x > y then x else y end;
    integer procedure min ( integer x, y ) ; begin if x < y then x else y end;
    integer x_min, y_min, x_max, y_max, a, b, x, y;
    string(255) array arr ( 1 :: 255 );
    real    h, w, m, s, t;
    x_min := y_min := 9999;
    x_max := y_max := 0;
    h := 96;
    w := h + h / 2;
    a := 1;
    b := 1;
    m := 6 * PI;
    s := .02;
    t := s;
    while t <= m do begin % build spiral %
      real r;
      r := a + b * t;
      x := round(r * cos(t) + w);
      y := round(r * sin(t) + h);
      if x <= 0 or y <= 0 then begin end
      else if x >= 280    then begin end
      else if y >= 192    then begin end
      else begin
        arr( x )( y // 1 ) := "*";
        x_min := min(x_min,x);
        x_max := max(x_max,x);
        y_min := min(y_min,y);
        y_max := max(y_max,y);
        t     := t + s
      end if__various_x_and_y_values__
    end while__t_le_m ;
    for i := x_min until x_max do begin
        for j := y_min until y_max do begin
            string(1) c;
            c := arr( i )( j // 1 );
            writeon( c, c )
        end for_j ;
        write()
    end for_i
end.
