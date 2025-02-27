program FractalTree;

uses
  cthreads, // Required for multithreading on supported platforms
  Math, PtcCrt, PtcGraph, SysUtils;

const
  TreeDepth = 17; // Maximum depth of the tree

procedure DrawTree(X1, Y1: Integer; Angle: Double; Depth: Integer);
var
  X2, Y2, Thickness: Integer;
begin
  if Depth = 0 then
    Exit;

  // Calculate the next point
  X2 := Trunc(X1 + Cos(DegToRad(Angle)) * Depth * 6);
  Y2 := Trunc(Y1 + Sin(DegToRad(Angle)) * Depth * 6);

  // Set the color based on depth
  SetColor(986895 * Depth);

  // Dynamically calculate thickness (thicker at smaller depths)
  Thickness := Max(1, Depth div 5); // Ensure thickness is at least 1
  SetLineStyle(0, 0, Thickness);

  // Draw the branch
  Line(X1, Y1, X2, Y2);

  // Recursively draw the left and right branches
  DrawTree(X2, Y2, Angle - 15, Depth - 1);
  DrawTree(X2, Y2, Angle + 15, Depth - 1);
end;

var
  ModeInfo: PModeInfo;
begin
  // Query and set the graphics mode for 1600x900 resolution with 24-bit color
  ModeInfo := QueryAdapterInfo;
  repeat
    ModeInfo := ModeInfo^.Next;
  until (ModeInfo^.MaxX = 1599) and (ModeInfo^.MaxY = 899) and (ModeInfo^.MaxColor = 16777216);

  InitGraph(ModeInfo^.DriverNumber, ModeInfo^.ModeNumber, '');

  // Draw the fractal tree
  DrawTree(ModeInfo^.MaxX div 2, ModeInfo^.MaxY, -90, TreeDepth);

  // Wait for user input before closing
  ReadKey;
  CloseGraph;
end.
