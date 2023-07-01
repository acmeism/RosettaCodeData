Program Bearings;
{ Reads pairs of angles from a file and subtracts them }

Const
  fileName = 'angles.txt';

Type
  degrees = real;

Var
  subtrahend, minuend: degrees;
  angleFile: text;

function Simplify(angle: degrees): degrees;
{ Returns an number in the range [-180.0, 180.0] }
  begin
    while angle > 180.0 do
      angle := angle - 360.0;
    while angle < -180.0 do
      angle := angle + 360.0;
    Simplify := angle
  end;

function Difference(b1, b2: degrees): degrees;
{ Subtracts b1 from b2 and returns a simplified result }
  begin
    Difference := Simplify(b2 - b1)
  end;

procedure Subtract(b1, b2: degrees);
{ Subtracts b1 from b2 and shows the whole equation onscreen }
  var
    b3: degrees;
  begin
    b3 := Difference(b1, b2);
    writeln(b2:20:11, '   - ', b1:20:11, '   = ', b3:20:11)
  end;

Begin
  assign(angleFile, fileName);
  reset(angleFile);
  while not eof(angleFile) do
    begin
      readln(angleFile, subtrahend, minuend);
      Subtract(subtrahend, minuend)
    end;
  close(angleFile)
End.
