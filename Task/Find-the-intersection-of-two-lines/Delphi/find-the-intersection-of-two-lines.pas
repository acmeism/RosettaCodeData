{Vector structs and operations - these would normally be in}
{a library, but are produced here so everything is explicit}

type T2DVector=packed record
  X,Y: double;
  end;

type T2DLine = packed record
 P1,P2: T2DVector;
 end;


function MakeVector2D(const X,Y: double): T2DVector;
begin
Result.X:=X;
Result.Y:=Y;
end;

function MakeLine2D(X1,Y1,X2,Y2: double): T2DLine;
begin
Result.P1:=MakeVector2D(X1,Y1);
Result.P2:=MakeVector2D(X2,Y2);
end;


function DoLinesIntersect2D(L1,L2: T2DLine; var Point: T2DVector): boolean;
{Finds intersect point only if the lines actually intersect}
var distAB, theCos, theSin, newX, ABpos: double;
begin
Result:=False;
{  Fail if either line segment is zero-length.}
if (L1.P1.X=L1.P2.X) and (L1.P1.Y=L1.P2.Y) or
   (L2.P1.X=L2.P2.X) and (L2.P1.Y=L2.P2.Y) then exit;

{  Fail if the segments share an end-point.}
if (L1.P1.X=L2.P1.X) and (L1.P1.Y=L2.P1.Y) or
   (L1.P2.X=L2.P1.X) and (L1.P2.Y=L2.P1.Y) or
   (L1.P1.X=L2.P2.X) and (L1.P1.Y=L2.P2.Y) or
   (L1.P2.X=L2.P2.X) and (L1.P2.Y=L2.P2.Y) then exit;

{  (1) Translate the system so that point A is on the origin.}
L1.P2.X:=L1.P2.X-L1.P1.X; L1.P2.Y:=L1.P2.Y-L1.P1.Y;
L2.P1.X:=L2.P1.X-L1.P1.X; L2.P1.Y:=L2.P1.Y-L1.P1.Y;
L2.P2.X:=L2.P2.X-L1.P1.X; L2.P2.Y:=L2.P2.Y-L1.P1.Y;

{  Discover the length of segment A-B.}
distAB:=sqrt(L1.P2.X*L1.P2.X+L1.P2.Y*L1.P2.Y);

{  (2) Rotate the system so that point B is on the positive X L1.P1.Xis.}
theCos:=L1.P2.X/distAB;
theSin:=L1.P2.Y/distAB;
newX:=L2.P1.X*theCos+L2.P1.Y*theSin;
L2.P1.Y  :=L2.P1.Y*theCos-L2.P1.X*theSin; L2.P1.X:=newX;
newX:=L2.P2.X*theCos+L2.P2.Y*theSin;
L2.P2.Y  :=L2.P2.Y*theCos-L2.P2.X*theSin; L2.P2.X:=newX;

{  Fail if segment C-D doesn't cross line A-B.}
if (L2.P1.Y<0) and (L2.P2.Y<0) or (L2.P1.Y>=0) and (L2.P2.Y>=0) then exit;

{  (3) Discover the position of the intersection point along line A-B.}
ABpos:=L2.P2.X+(L2.P1.X-L2.P2.X)*L2.P2.Y/(L2.P2.Y-L2.P1.Y);

{  Fail if segment C-D crosses line A-B outside of segment A-B.}
if (ABpos<0) or (ABpos>distAB) then exit;

{  (4) Apply the discovered position to line A-B in the original coordinate system.}
Point.X:=L1.P1.X+ABpos*theCos;
Point.Y:=L1.P1.Y+ABpos*theSin;
Result:=True;
end;

procedure TestIntersect(Memo: TMemo; L1,L2: T2DLine);
var Int: T2DVector;
var S: string;
begin
Memo.Lines.Add('Line-1: '+Format('(%1.0f,%1.0f)->(%1.0f,%1.0f)',[L1.P1.X,L1.P1.Y,L1.P2.X,L1.P2.Y]));
Memo.Lines.Add('Line-2: '+Format('(%1.0f,%1.0f)->(%1.0f,%1.0f)',[L2.P1.X,L2.P1.Y,L2.P2.X,L2.P2.Y]));
if DoLinesIntersect2D(L1,L2,Int) then Memo.Lines.Add(Format('Intersect = %2.1f %2.1f',[Int.X,Int.Y]))
else Memo.Lines.Add('No Intersect.');
end;

procedure TestLineIntersect(Memo: TMemo);
var L1,L2: T2DLine;
var S: string;
begin
L1:=MakeLine2D(4,0,6,10);
L2:=MakeLine2D(0,3,10,7);
TestIntersect(Memo,L1,L2);
Memo.Lines.Add('');
L1:=MakeLine2D(0,0,1,1);
L2:=MakeLine2D(1,2,4,5);
TestIntersect(Memo,L1,L2);
end;
