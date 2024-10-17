program ScreenPixel;

{$APPTYPE CONSOLE}

uses
  Windows,
  SysUtils,
  Graphics;


// Use this function in a GUI application to return the color
function GetPixelColourAsColor(const PixelCoords: TPoint): TColor;
var
  dc: HDC;
begin
  // Get Device Context of windows desktop
  dc := GetDC(0);
  // Read the color of the pixel at the given coordinates
  Result := GetPixel(dc,PixelCoords.X,PixelCoords.Y);
end;

// Use this function to get a string representation of the current colour
function GetPixelColourAsString(const PixelCoords: TPoint): string;
var
  r,g,b: Byte;
  col: TColor;
begin
  col := GetPixelColourAsColor(PixelCoords);

  // Convert the Delphi TColor value to it's RGB components
  r := col and $FF;
  g := (col shr 8) and $FF;
  b := (col shr 16) and $FF;

  // Format the result
  Result := 'R('+IntToStr(r)+') G('+IntToStr(g)+') G('+IntToStr(b)+')';

  {
    Alternatively, format the result as follows to get a
    string representation of the Delphi TColor value

    Result := ColorToString(GetPixel(dc,curP.X,curP.Y));
  }

end;

var
  s: string;
  P: TPoint;
begin
  s := '';

  Writeln('Move mouse over a pixel. Hit return to get colour of selected pixel.');

  repeat
    Readln(s);
    if s = '' then
      begin
        GetCursorPos(P);
        Writeln('Colour at cursor position X:'+
                IntToStr(P.X)+' Y:'+
                IntToStr(P.Y) +' = '+
                GetPixelColourAsString(P)
                );
        Writeln('');
        Writeln('Move mouse and hit enter again.');
      end;
  until
    SameText(s,'quit');

end.
