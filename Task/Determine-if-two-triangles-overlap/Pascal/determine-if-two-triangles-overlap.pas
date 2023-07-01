program TrianglesOverlap;
{
The program looks for a separating line between the triangles. It's known that
only the triangle sides (produced) need to be considered as possible separators
(except in the degenerate case when both triangles are reduced to a point).
If there's a strong separator, i.e. one that is disjoint from at least one
of the triangles, then the triangles are disjoint. If there's only a weak
separator, i.e. one that intersects both triangles, then the triangles intersect
in a point or a line segment (this program doesn't work out which).
If there's no separator, then the triangles have an overlap of positive area.
}
{$IFDEF FPC}
  {$mode objfpc}{$H+}
{$ENDIF}}

uses Math, SysUtils;

{$DEFINE USE_FP}
{$IFDEF USE_FP}
type TCoordinate = double;
const TOLERANCE = 1.0E-6;
{$ELSE}
type TCoordinate = integer;
const TOLERANCE = 0;
{$ENDIF}

type TVertex = record
  x, y : TCoordinate;
end;

function Vertex( x_in, y_in : TCoordinate) : TVertex;
begin
  result.x := x_in;
  result.y := y_in;
end;

// Result of testing sides of a triangle for separator.
// Values are arbitrary but must be in this numerical order
const
  SEP_NO_TEST = -1; // triangle is a single point, no sides to be tested
  SEP_NONE    = 0;  // didn't find a separator
  SEP_WEAK    = 1;  // found a weak separator only
  SEP_STRONG  = 2;  // found a strong separator

function EqualVertices( V, W : TVertex) : boolean;
begin
  result := (Abs(V.x - W.x) <= TOLERANCE)
        and (Abs(V.y - W.y) <= TOLERANCE);
end;

// Determinant: twice the signed area of triangle PQR.
function Det( P, Q, R : TVertex) : TCoordinate;
begin
  result := Q.x*R.y - R.x*Q.y + R.x*P.y - P.x*R.y + P.x*Q.y - Q.x*P.y;
end;

// Get result of trying sides of LMN as separators.
function TrySides( L, M, N, P, Q, R : TVertex) : integer;
var
  s, sMin, sMax: TCoordinate;
  H, K : TVertex;

      function TestSide( V, W : TVertex) : integer;
      var
        detP, detQ, detR, tMin, tMax : TCoordinate;
      begin
        result := SEP_NONE;
        detP := Det( V, W, P);
        detQ := Det( V, W, Q);
        detR := Det( V, W, R);
        tMin := Math.Min( Math.Min( detP, detQ), detR);
        tMax := Math.Max( Math.Max( detP, detQ), detR);
        if (tMin - sMax > TOLERANCE) or (sMin - tMax > TOLERANCE) then
          result := SEP_STRONG
        else if (tMin - sMax >= -TOLERANCE) or (sMin - tMax >= -TOLERANCE) then
          result := SEP_WEAK;
      end;

begin
  sMin := 0;
  sMax := 0;
  s := Det( L, M, N);
  if (s <> 0) then begin // L, M, N are not collinear
    if (s < 0) then sMin := s else sMax := s;
    // Once we've found a strong separator, there's no need for further testing
    result := TestSide( M, N);
    if (result < SEP_STRONG) then result := Math.Max( result, TestSide( N, L));
    if (result < SEP_STRONG) then result := Math.Max( result, TestSide( L, M));
  end
  else begin // s = 0 so L, M, N are collinear
    // Look for distinct vertices from among L, M, N
    H := L;
    K := M;
    if EqualVertices( H, K) then K := N;
    if EqualVertices( H, K) then result := SEP_NO_TEST // L = M = N
    else result := TestSide( H, K);
  end;
end;

function Algo_5( A, B, C, D, E, F : TVertex) : integer;
begin
  result := TrySides( A, B, C, D, E, F);
  if (result < SEP_STRONG) then begin
    result := Math.Max( result, TrySides( D, E, F, A, B, C));
    if (result = SEP_NO_TEST) then begin // A = B = C and D = E = F
      if EqualVertices( A, D) then result := SEP_WEAK
                              else result := SEP_STRONG;
    end;
  end;
end;

procedure TestTrianglePair (Ax, Ay, Bx, By, Cx, Cy,
                            Dx, Dy, Ex, Ey, Fx, Fy : TCoordinate);
var
  ovStr : string;
begin
  case Algo_5( Vertex(Ax, Ay), Vertex(Bx, By), Vertex(Cx, Cy),
               Vertex(Dx, Dy), Vertex(Ex, Ey), Vertex(Fx, Fy)) of
    SEP_STRONG : ovStr := 'Disjoint';
    SEP_NONE   : ovStr := 'Overlap';
    else         ovStr := 'Borderline';
  end;
  WriteLn( SysUtils.Format(
      '(%g,%g),(%g,%g),(%g,%g) and (%g,%g),(%g,%g),(%g,%g): %s',
       [Ax, Ay, Bx, By, Cx, Cy, Dx, Dy, Ex, Ey, Fx, Fy, ovStr]));
end;

// Main routine
begin
  TestTrianglePair( 0,0,5,0,0,5, 0,0,5,0,0,6);
  TestTrianglePair( 0,0,0,5,5,0, 0,0,0,5,5,0);
  TestTrianglePair( 0,0,5,0,0,5, -10,0,-5,0,-1,6);
  TestTrianglePair( 0,0,5,0,2.5,5, 0,4,2.5,-1,5,4);
  TestTrianglePair( 0,0,1,1,0,2, 2,1,3,0,3,2);
  TestTrianglePair( 0,0,1,1,0,2, 2,1,3,-2,3,4);
  TestTrianglePair( 0,0,1,0,0,1, 1,0,2,0,1,1);
end.
