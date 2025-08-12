program rdpalgor (output);
(* Ramer-Douglas-Peucker line simplification *)
const
  len = 10;

type
  tpnt = record
    x, y: real;
  end;
  tpnts = array [0 .. len] of tpnt;

var
  pntsin, pntsout: tpnts;
  n: integer;

  procedure writepnts(pnts: tpnts; n: integer);
  var
    i: integer;
  begin
    write('(', pnts[0].x: 8, ', ', pnts[0].y: 8, ')');
    for i := 1 to n - 1 do
      write(' (', pnts[i].x: 8, ', ', pnts[i].y: 8, ')');
    writeln;
  end;

  (* Returns the distance from point P to the line between P1 and P2 *)
  function perpdist(p, p1, p2: tpnt): real;
  var
    dx, dy, d: real;
  begin
    dx := p2.x - p1.x;
    dy := p2.y - p1.y;
    d := sqrt(dx * dx + dy * dy);
    perpdist := abs(p.x * dy - p.y * dx + p2.x * p1.y - p2.y * p1.x) / d;
  end;

  (* Simplify an array of points using the Ramer-Douglas-Peucker algorithm. *)
  (* Returns the number of output points. *)
  function rdp(src: tpnts; srcfrom, srclen: integer; eps: real;
    var dest: tpnts; destfrom, destlen: integer): integer;
  var
    dist, maxdist             : real;
    n1, n2, i, maxdisti, srcto: integer;
    src1len, src2len, src2from: integer;
  begin
    maxdist := 0.0;
    maxdisti := srcfrom;
    srcto := srcfrom + srclen - 1;
    for i := srcfrom + 1 to srcto - 1 do
    begin
      dist := perpdist(src[i], src[srcfrom], src[srcto]);
      if dist > maxdist then
      begin
        maxdist := dist;
        maxdisti := i
      end;
    end;
    src2from := maxdisti;
    src1len := maxdisti - srcfrom + 1;
    src2len := srclen - src1len + 1;
    if maxdist > eps then
    begin
      n1 := rdp(src, srcfrom, src1len, eps, dest, destfrom, destlen);
      if destlen >= n1 - 1 then
        n2 := rdp(src, src2from, src2len, eps, dest, destfrom + n1 - 1, destlen - n1 + 1)
      else
        n2 := rdp(src, src2from, src2len, eps, dest, destfrom, 0);
      rdp := n1 + n2 - 1;
    end
    else
    begin
      if destlen > 1 then
      begin
        dest[destfrom] := src[srcfrom];
        dest[destfrom + 1] := src[srcto];
      end;
      rdp := 2;
    end;
  end;

begin
  pntsin[0].x := 0.0; pntsin[0].y := 0.0;
  pntsin[1].x := 1.0; pntsin[1].y := 0.1;
  pntsin[2].x := 2.0; pntsin[2].y := -0.1;
  pntsin[3].x := 3.0; pntsin[3].y := 5.0;
  pntsin[4].x := 4.0; pntsin[4].y := 6.0;
  pntsin[5].x := 5.0; pntsin[5].y := 7.0;
  pntsin[6].x := 6.0; pntsin[6].y := 8.1;
  pntsin[7].x := 7.0; pntsin[7].y := 9.0;
  pntsin[8].x := 8.0; pntsin[8].y := 9.0;
  pntsin[9].x := 9.0; pntsin[9].y := 9.0;
  n := rdp(pntsin, 0, len, 1.0, pntsout, 0, len);
  writepnts(pntsout, n);
end.
