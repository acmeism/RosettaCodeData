{$mode ISO}  { Tell Free Pascal Compiler to use "ISO 7185" mode. }

{

This is the algorithm of the Icon example, recast as a recursive
procedure.

The "var" notation in formal parameter lists means pass by
reference. All other parameters are implicitly passed by value.

Pascal is case-insensitive.

In the old days, when Pascal was printed as a means to express
algorithms, it was usually in a fashion similar to Algol 60 reference
language. It was printed mostly in lowercase and did not have
underscores. Reserved words were in boldface and variables, etc., were
in italics. The effect was like that of Algol 60 reference language.

Code entry practices for Pascal were another matter. It may have been
all uppercase, with ML-style comment braces instead of squiggly
braces. It may have had uppercase reserved words and "Pascal case"
variables, etc., as one sees also in Modula-2 and Oberon-2 code.

Here I have deliberately adopted an all-lowercase style.

References on the s-power basis:

  J. Sánchez-Reyes, ‘The symmetric analogue of the polynomial power
      basis’, ACM Transactions on Graphics, vol 16 no 3, July 1997,
      page 319.

  J. Sánchez-Reyes, ‘Applications of the polynomial s-power basis in
      geometry processing’, ACM Transactions on Graphics, vol 19 no 1,
      January 2000, page 35.

}

program bezierintersections;

const
  flatnesstolerance = 0.0001;
  minimumspacing = 0.000001;
  maxintersections = 10;

type
  point =
    record
      x, y : real
    end;
  spower = { non-parametric spline in s-power basis }
    record
      c0, c1, c2 : real
    end;
  curve =  { parametric spline in s-power basis }
    record
      x, y : spower
    end;
  portion = { portion of a parametric spline in [t0,t1] }
    record
      curv           : curve;
      t0, t1         : real;
      endpt0, endpt1 : point { pre-computed for efficiency }
    end;
  intersectionscount = 0 .. maxintersections;
  intersectionsrange = 1 .. maxintersections;
  tparamsarray = array [intersectionsrange] of real;
  coordsarray = array [intersectionsrange] of point;

var
  numintersections : intersectionscount;
  tparamsp : tparamsarray;
  coordsp : coordsarray;
  tparamsq : tparamsarray;
  coordsq : coordsarray;
  pglobal, qglobal : curve;
  i : integer;

{ Minimum of two real. }
function rmin (x, y : real) : real;
begin
  if x < y then rmin := x else rmin := y
end;

{ Maximum of two real. }
function rmax (x, y : real) : real;
begin
  if x < y then rmax := y else rmax := x
end;

{ Insertion sort of an array of real. }
procedure realsort (    n : integer;
                    var a : array of real);
var
  i, j : integer;
  x : real;
  done : boolean;
begin
  i := low (a) + 1;
  while i < n do
    begin
      x := a[i];
      j := i - 1;
      done := false;
      while not done do
        begin
          if j + 1 = low (a) then
            done := true
          else if a[j] <= x then
            done := true
          else
            begin
              a[j + 1] := a[j];
              j := j - 1
            end
        end;
      a[j + 1] := x;
      i := i + 1
    end
end;

{ "Length" according to some definition. Here I use a max norm.  The
  "distance" between two points is the "length" of the differences of
  the corresponding coordinates. (The sign of the difference should be
  immaterial.) }
function length (ax, ay : real) : real;
begin
  length := rmax (abs (ax), abs (ay))
end;

{ Having a "comparelengths" function makes it possible to use a
  euclidean norm for "length", and yet avoid square roots. One
  compares the squares of lengths, instead of the lengths
  themselves. However, here I use a more general implementation. }
function comparelengths (ax, ay, bx, by : real) : integer;
var lena, lenb : real;
begin
  lena := length (ax, ay);
  lenb := length (bx, by);
  if lena < lenb then
    comparelengths := -1
  else if lena > lenb then
    comparelengths := 1
  else
    comparelengths := 0
end;

function makepoint (x, y : real) : point;
begin
  makepoint.x := x;
  makepoint.y := y
end;

function makeportion (curv           : curve;
                      t0, t1         : real;
                      endpt0, endpt1 : point) : portion;
begin
  makeportion.curv := curv;
  makeportion.t0 := t0;
  makeportion.t1 := t1;
  makeportion.endpt0 := endpt0;
  makeportion.endpt1 := endpt1;
end;

{ Convert from control points (that is, Bernstein basis) to the
  symmetric power basis. }
function controlstospower (ctl0, ctl1, ctl2 : point) : curve;
begin
  controlstospower.x.c0 := ctl0.x;
  controlstospower.y.c0 := ctl0.y;
  controlstospower.x.c1 := (2.0 * ctl1.x) - ctl0.x - ctl2.x;
  controlstospower.y.c1 := (2.0 * ctl1.y) - ctl0.y - ctl2.y;
  controlstospower.x.c2 := ctl2.x;
  controlstospower.y.c2 := ctl2.y
end;

{ Evaluate an s-power spline at t. }
function spowereval (spow : spower;
                     t    : real) : real;
begin
  spowereval := (spow.c0 + (spow.c1 * t)) * (1.0 - t) + (spow.c2 * t)
end;

{ Evaluate a curve at t. }
function curveeval (curv : curve;
                    t    : real) : point;
begin
  curveeval.x := spowereval (curv.x, t);
  curveeval.y := spowereval (curv.y, t)
end;

{ Return the center coefficient for the [t0,t1] portion of an s-power
  spline. (The endpoint coefficients can be found with spowereval.) }
function spowercentercoef (spow   : spower;
                           t0, t1 : real) : real;
begin
  spowercentercoef := spow.c1 * ((t1 - t0 - t0) * t1 + (t0 * t0))
end;

{ Return t in (0,1) where spow is at a critical point, else return
  -1.0. }
function spowercriticalpt (spow : spower) : real;
var t : real;
begin
  spowercriticalpt := -1.0;
  if spow.c1 <> 0.0 then { If c1 is zero, then the spline is linear. }
    begin
      if spow.c1 = spow.c2 then
        spowercriticalpt := 0.5 { The spline is "pulse-like". }
      else
        begin
          { t = root of the derivative }
          t := (spow.c2 + spow.c1 - spow.c0) / (spow.c1 + spow.c1);
          if (0.0 < t) and (t < 1.0) then
            spowercriticalpt := t
        end
    end
end;

{ Bisect a portion and pre-compute the new shared endpoint. }
procedure bisectportion (    port         : portion;
                         var port1, port2 : portion);
begin
  port1.curv := port.curv;
  port2.curv := port.curv;

  port1.t0 := port.t0;
  port1.t1 := 0.5 * (port.t0 + port.t1);
  port2.t0 := port1.t1;
  port2.t1 := port.t1;

  port1.endpt0 := port.endpt0;
  port1.endpt1 := curveeval (port.curv, port1.t1);
  port2.endpt0 := port1.endpt1;
  port2.endpt1 := port.endpt1;
end;

{ Do the rectangles with corners at (a0,a1) and (b0,b1) overlap at
  all? }
function rectanglesoverlap (a0, a1, b0, b1 : point) : boolean;
begin
  rectanglesoverlap := ((rmin (a0.x, a1.x) <= rmax (b0.x, b1.x))
                        and (rmin (b0.x, b1.x) <= rmax (a0.x, a1.x))
                        and (rmin (a0.y, a1.y) <= rmax (b0.y, b1.y))
                        and (rmin (b0.y, b1.y) <= rmax (a0.y, a1.y)))
end;

{ Set the respective [0,1] parameters of line segments (a0,a1) and
  (b0,b1), for their intersection point. If there are not two such
  parameters, set both values to -1.0. }
procedure segmentparameters (    a0, a1, b0, b1 : point;
                             var ta, tb         : real);
var
  anumer, bnumer, denom : real;
  axdiff, aydiff, bxdiff, bydiff : real;
begin
  axdiff := a1.x - a0.x;
  aydiff := a1.y - a0.y;
  bxdiff := b1.x - b0.x;
  bydiff := b1.y - b0.y;

  denom := (axdiff * bydiff) - (aydiff * bxdiff);

  anumer := ((bxdiff * a0.y) - (bydiff * a0.x)
             + (b0.x * b1.y) - (b1.x * b0.y));
  ta := anumer / denom;
  if (ta < 0.0) or (1.0 < ta) then
    begin
      ta := -1.0;
      tb := -1.0
    end
  else
    begin
      bnumer := -((axdiff * b0.y) - (aydiff * b0.x)
                  + (a0.x * a1.y) - (a1.x * a0.y));
      tb := bnumer / denom;
      if (tb < 0.0) or (1.0 < tb) then
        begin
          ta := -1.0;
          tb := -1.0
        end
    end
end;

{ Is a curve portion flat enough to be treated as a line segment
  between its endpoints? }
function flatenough (port : portion;
                     tol  : real) : boolean;
var
  xcentercoef, ycentercoef : real;
begin

  { The degree-2 s-power polynomials are 1-t, t(1-t), t. We want to
    remove the terms in t(1-t). The maximum of t(1-t) is 1/4, reached
    at t=1/2. That accounts for the 1/4=0.25 in the following. }

  { The "with" construct here is a shorthand to implicitly use fields
    of the "port" record. Thus "curv.x" means "port.curv.x", etc. }
  with port do
    begin
      xcentercoef := spowercentercoef (curv.x, t0, t1);
      ycentercoef := spowercentercoef (curv.y, t0, t1);
      flatenough := comparelengths (0.25 * xcentercoef,
                                    0.25 * ycentercoef,
                                    tol * (endpt1.x - endpt0.x),
                                    tol * (endpt1.y - endpt0.y)) <= 0
    end
end;

{ If the intersection point corresponding to tp and tq is not already
  listed, insert it into the arrays, sorted by the value of tp. }
procedure insertintersection (p  : curve;
                              tp : real;
                              q  : curve;
                              tq : real);
var
  ppoint, qpoint : point;
  lenp, lenq : real;
  i : intersectionscount;
  insertionpoint : intersectionscount;
begin
  if numintersections <> maxintersections then
    begin
      ppoint := curveeval (p, tp);
      qpoint := curveeval (q, tq);

      insertionpoint := numintersections + 1; { Insert at end. }
      i := 0;
      while (0 < insertionpoint) and (i <> numintersections) do
        begin
          i := i + 1;
          lenp := length (coordsp[i].x - ppoint.x,
                          coordsp[i].y - ppoint.y);
          lenq := length (coordsq[i].x - qpoint.x,
                          coordsq[i].y - qpoint.y);
          if (lenp < minimumspacing) and (lenq < minimumspacing) then
            insertionpoint := 0 { The point is already listed. }
          else if tp < tparamsp[i] then
            begin
              insertionpoint := i; { Insert here instead of at end. }
              i := numintersections
            end
        end;

      if insertionpoint <> numintersections + 1 then
        for i := numintersections + 1 downto insertionpoint + 1 do
          begin
            tparamsp[i] := tparamsp[i - 1];
            coordsp[i]  := coordsp[i - 1];
            tparamsq[i] := tparamsq[i - 1];
            coordsq[i]  := coordsq[i - 1]
          end;

      tparamsp[insertionpoint] := tp;
      coordsp[insertionpoint]  := ppoint;
      tparamsq[insertionpoint] := tq;
      coordsq[insertionpoint]  := qpoint;

      numintersections := numintersections + 1
    end
end;

{ Find intersections between portions of two curves. }
procedure findportionintersections (pportion, qportion : portion);
var
  tp, tq : real;
  pport1, pport2 : portion;
  qport1, qport2 : portion;
begin
  if rectanglesoverlap (pportion.endpt0, pportion.endpt1,
                        qportion.endpt0, qportion.endpt1) then
    begin
      if flatenough (pportion, flatnesstolerance) then
        begin
          if flatenough (qportion, flatnesstolerance) then
            begin
              segmentparameters (pportion.endpt0, pportion.endpt1,
                                 qportion.endpt0, qportion.endpt1,
                                 tp, tq);
              if 0.0 <= tp then
                begin
                  tp := (1.0 - tp) * pportion.t0 + tp * pportion.t1;
                  tq := (1.0 - tq) * qportion.t0 + tq * qportion.t1;
                  insertintersection (pportion.curv, tp,
                                      qportion.curv, tq)
                end
            end
          else
            begin
              bisectportion (qportion, qport1, qport2);
              findportionintersections (pportion, qport1);
              findportionintersections (pportion, qport2)
            end
        end
      else
        begin
          bisectportion (pportion, pport1, pport2);
          if flatenough (qportion, flatnesstolerance) then
            begin
              findportionintersections (pport1, qportion);
              findportionintersections (pport2, qportion)
            end
          else
            begin
              bisectportion (qportion, qport1, qport2);
              findportionintersections (pport1, qport1);
              findportionintersections (pport1, qport2);
              findportionintersections (pport2, qport1);
              findportionintersections (pport2, qport2)
            end
        end
    end
end;

{ Find intersections in [0,1]. }
procedure findintersections (p, q : curve);
var
  tpx, tpy, tqx, tqy : real;
  tp, tq : array [1 .. 4] of real;
  ppoints, qpoints : array [1 .. 4] of point;
  np, nq, i, j : integer;
  pportion, qportion : portion;

  procedure pfindcriticalpts;
  var i : integer;
  begin
    tp[1] := 0.0;
    tp[2] := 1.0;
    np := 2;
    tpx := spowercriticalpt (p.x);
    tpy := spowercriticalpt (p.y);
    if (0.0 < tpx) and (tpx < 1.0) then
      begin
        np := np + 1;
        tp[np] := tpx
      end;
    if (0.0 < tpy) and (tpy < 1.0) and (tpy <> tpx) then
      begin
        np := np + 1;
        tp[np] := tpy
      end;
    realsort (np, tp);
    for i := 1 to np do
      ppoints[i] := curveeval (p, tp[i])
  end;

  procedure qfindcriticalpts;
  var i : integer;
  begin
    tq[1] := 0.0;
    tq[2] := 1.0;
    nq := 2;
    tqx := spowercriticalpt (q.x);
    tqy := spowercriticalpt (q.y);
    if (0.0 < tqx) and (tqx < 1.0) then
      begin
        nq := nq + 1;
        tq[nq] := tqx
      end;
    if (0.0 < tqy) and (tqy < 1.0) and (tqy <> tqx) then
      begin
        nq := nq + 1;
        tq[nq] := tqy
      end;
    realsort (nq, tq);
    for i := 1 to nq do
      qpoints[i] := curveeval (q, tq[i])
  end;

begin
  { Break the curves at critical points, so one can assume the portion
    between two endpoints is monotonic along both axes. }
  pfindcriticalpts;
  qfindcriticalpts;

  { Find intersections in the cartesian product of portions of the two
    curves. (If you would like to compare with the Icon code: In the
    Icon, goal-directed evaluation is inserting such cartesian
    products into the "workload" set. However, to do this requires
    only one "every" construct instead of two, and there is no need
    for loop/counter variables.) }
  for i := 1 to np - 1 do
    for j := 1 to nq - 1 do
      begin
        pportion := makeportion (p, tp[i], tp[i + 1],
                                 ppoints[i], ppoints[i + 1]);
        qportion := makeportion (q, tq[j], tq[j + 1],
                                 qpoints[j], qpoints[j + 1]);
        findportionintersections (pportion, qportion);
      end
end;

begin
  pglobal := controlstospower (makepoint (-1.0,  0.0),
                               makepoint ( 0.0, 10.0),
                               makepoint ( 1.0,  0.0));
  qglobal := controlstospower (makepoint ( 2.0,  1.0),
                               makepoint (-8.0,  2.0),
                               makepoint ( 2.0,  3.0));
  numintersections := 0;
  findintersections (pglobal, qglobal);
  writeln;
  writeln ('          convex up                ',
           '                    convex left');
  for i := 1 to numintersections do
    writeln (' ',
             tparamsp[i]:11:8, '   (',
             coordsp[i].x:11:8, ', ',
             coordsp[i].y:11:8, ')     ',
             tparamsq[i]:11:8, '   (',
             coordsq[i].x:11:8, ', ',
             coordsq[i].y:11:8, ')');
  writeln
end.
