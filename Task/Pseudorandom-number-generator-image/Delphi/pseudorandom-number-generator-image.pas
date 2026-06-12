program Pseudorandom_number_generator_image;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  vcl.Graphics,
  Vcl.Imaging.PngImage;

type
  TRGBTriple = packed record
    b: Byte;
    g: Byte;
    r: Byte;
  end;

  PRGBTripleArray = ^TRGBTripleArray;

  TRGBTripleArray = array[0..999] of TRGBTriple;

function Noise(cWidth, cHeight: Integer; Color: boolean = True): TBitmap;
const
  Seed = 2147483647;
var
  Pixels: PRGBTripleArray;
begin
  RandSeed := Seed;
  Result := TBitmap.Create;
  with Result do
  begin
    SetSize(cWidth, cHeight);
    PixelFormat := pf24bit;
    for var row := 0 to cHeight - 1 do
    begin
      Pixels := ScanLine[row];
      for var col := 0 to cWidth - 1 do
      begin
        if Color then
        begin
          Pixels[col].r := random(255);
          Pixels[col].g := random(255);
          Pixels[col].b := random(255);
        end
        else
        begin
          var Gray := Round((0.299 * random(255)) + (0.587 * random(255)) + (0.114
            * random(255)));
          Pixels[col].r := Gray;
          Pixels[col].g := Gray;
          Pixels[col].b := Gray;
        end;
      end;
    end;
  end;
end;

const
  cWidth = 1000;
  cHeight = 1000;

begin
  // Color noise
  var bmp := Noise(cWidth, cHeight);
  bmp.SaveToFile('randbitmap-rdo.bmp');

  // to Png
  with TPngImage.create do
  begin
    Assign(bmp);
    SaveToFile('randbitmap-rdo.png');
    free;
  end;
  bmp.Free;

  // Gray noise
  bmp := Noise(cWidth, cHeight, False);
  bmp.SaveToFile('randbitmap-rdo_g.bmp');

  // to Png
  with TPngImage.create do
  begin
    Assign(bmp);
    SaveToFile('randbitmap-rdo_g.png');
    free;
  end;
  bmp.Free;

end.
