program cistnums;
(* Cistercian numerals *)
const
  maxcoord = 14;

type
  tcanvas = array [0 .. maxcoord, 0 .. maxcoord] of char;
  tsignvals = -1 .. 1;

  (* BEGIN. Operations on the tcanvas ADT. *)
  procedure clearcanvas(var canvas: tcanvas);
  var
    i, j: integer;
  begin
    for i := 0 to maxcoord do
      for j := 0 to maxcoord do
        canvas[i, j] := ' ';
  end; (* clearcanvas *)

  procedure drawline(var canvas: tcanvas; r0, c0: integer;
    dist: integer; dr, dc: tsignvals);
  (* Draws a straight (vertical, horizontal, or diagonal) line
    from canvas[r0, c0] to canvas[r0 + dr * dist, c0 + dc * dist]. *)
  var
    c, r, i: integer;
  begin
    r := r0;
    c := c0;
    for i := 0 to dist do
    begin
      canvas[r, c] := '*';
      r := r + dr;
      c := c + dc;
    end;
  end; (* drawline *)

  procedure showcanvas(var canvas: tcanvas);
  var
    i, j: integer;
  begin
    for i := 0 to maxcoord do
    begin
      for j := 0 to maxcoord do
        write(canvas[i, j]);
      writeln;
    end;
  end; (* showcanvas *)
  (* END Operations on the tcanvas ADT. *)

  procedure drawnumber(var canvas: tcanvas; v: integer);
  (* drawdigit is part of the algorithm, so it is nested in drawnumber. *)
  type
    tdigits = 0 .. 9;
  var
    thousands, hundreds, tens, ones: integer;
    raxis, caxis: integer;

    procedure drawdigit(v: tdigits; rs, cs: tsignvals);
    (* rs, cs are signs of rows and cols in in relation to the axis.
      They decide in which quadrant a digit is located. *)
    begin
      case v of
        1: drawline(canvas, raxis + rs * 7, caxis + cs, 4, 0, cs);
        2: drawline(canvas, raxis + rs * 3, caxis + cs, 4, 0, cs);
        3: drawline(canvas, raxis + rs * 7, caxis + cs, 4, -rs, cs);
        4: drawline(canvas, raxis + rs * 3, caxis + cs, 4, rs, cs);
        5:
        begin
          drawdigit(1, rs, cs);
          drawdigit(4, rs, cs);
        end;
        6: drawline(canvas, raxis + rs * 3, caxis + cs * 5, 4, rs, 0);
        7:
        begin
          drawdigit(1, rs, cs);
          drawdigit(6, rs, cs);
        end;
        8:
        begin
          drawdigit(2, rs, cs);
          drawdigit(6, rs, cs);
        end;
        9:
        begin
          drawdigit(1, rs, cs);
          drawdigit(8, rs, cs);
        end;
      end;
    end; (* drawdigit *)

  begin (* drawnumber *)
    raxis := maxcoord div 2;
    caxis := 5;
    drawline(canvas, 0, caxis, maxcoord, 1, 0); (* Draw 0 (or vertical axis) *)
    thousands := v div 1000;
    v := v mod 1000;
    hundreds := v div 100;
    v := v mod 100;
    tens := v div 10;
    ones := v mod 10;
    if thousands > 0 then
      drawdigit(thousands, 1, -1);
    if hundreds > 0 then
      drawdigit(hundreds, 1, 1);
    if tens > 0 then
      drawdigit(tens, -1, -1);
    if ones > 0 then
      drawdigit(ones, -1, 1);
  end; (* drawnumber *)

  procedure test(n: integer);
  var
    canvas: tcanvas;
  begin
    writeln(n, ':');
    clearcanvas(canvas);
    drawnumber(canvas, n);
    showcanvas(canvas);
    writeln;
  end;

begin
  test(0);
  test(1);
  test(20);
  test(300);
  test(4000);
  test(5555);
  test(6789);
  test(9999)
end.
