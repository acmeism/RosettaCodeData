program ChaosGame;

// FPC 3.0.2
uses
  Graph, windows, math;

// Return a point on a circle defined by angle and the circles radius
// Angle 0 = Radius points to the left
// Angle 90 = Radius points upwards
Function PointOfCircle(Angle: SmallInt; Radius: integer): TPoint;
var Ia: Double;
begin
  Ia:=DegToRad(-Angle);
  result.x:=round(cos(Ia)*Radius);
  result.y:=round(sin(Ia)*Radius);
end;

{ Main }

var
  GraphDev,GraphMode: smallint;
  Triangle: array[0..2] of Tpoint; // Corners of the triangle
  TriPnt: Byte;                    // Point in ^^^^
  Origin: TPoint;                  // Defines center of triangle
  Itterations: integer;            // Number of Itterations
  Radius: Integer;
  View: viewPorttype;
  CurPnt: TPoint;
  Rect: TRect;
  Counter: integer;
begin

  Repeat {forever}

    // Get the Itteration count 0=exit
    Write('Itterations: ');
    ReadLn(Itterations);

    if Itterations=0 then halt;

    // Set Up Graphics screen (everythings Auto detect)
    GraphDev:=Detect;
    GraphMode:=0;
    InitGraph(GraphDev,GraphMode,'');
    if GraphResult<>grok then
    begin
      Writeln('Graphics doesn''t work');
      Halt;
    end;

    // set Origin to center of the _Triangle_ (Not the creen)
    GetViewSettings(View);
    Rect.Create(View.x1,View.y1+10,View.x2,View.y2-10);
    Origin:=Rect.CenterPoint;
    Origin.Offset(0,Rect.Height div 6);  //  Center Triangle on screen

    // Define Equilateral triangle,
    Radius:=Origin.y;         // Radius of Circumscribed circle
    for Counter:=0 to 2 do
      Triangle[Counter]:=PointOfCircle((Counter*120)+90,Radius)+Origin;

    // Choose random starting point, in the incsribed circle of the triangle
    Radius:=Radius div 2;     // Radius of inscribed circle
    CurPnt:=PointOfCircle(random(360),random(Radius div 2))+Origin;

    // Play the Chaos Game
    for Counter:=0 to Itterations do
    begin
      TriPnt:=Random(3);                      // Select Triangle Point
      Rect.Create(Triangle[TriPnt],CurPnt);;  // Def. rect. between TriPnt and CurPnt
      CurPnt:=Rect.CenterPoint;               // New CurPnt is center of rectangle
      putPixel(CurPnt.x,CurPnt.y,cyan);       // Plot the new CurPnt
    end;

  until False;
end.
