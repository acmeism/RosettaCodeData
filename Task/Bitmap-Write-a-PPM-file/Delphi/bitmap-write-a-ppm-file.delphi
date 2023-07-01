program btm2ppm;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Vcl.Graphics;

type
  TBitmapHelper = class helper for TBitmap
  public
    procedure SaveAsPPM(FileName: TFileName);
  end;

{ TBitmapHelper }

procedure TBitmapHelper.SaveAsPPM(FileName: TFileName);
var
  i, j, color: Integer;
  Header: AnsiString;
  ppm: TMemoryStream;
begin
  ppm := TMemoryStream.Create;
  try
    Header := Format('P6'#10'%d %d'#10'255'#10, [Self.Width, Self.Height]);
    writeln(Header);
    ppm.Write(Tbytes(Header), Length(Header));

    for i := 0 to Self.Height - 1 do
      for j := 0 to Self.Width - 1 do
      begin
        color := ColorToRGB(Self.Canvas.Pixels[i, j]);
        ppm.Write(color, 3);
      end;
    ppm.SaveToFile(FileName);
  finally
    ppm.Free;
  end;
end;

begin
  with TBitmap.Create do
  begin
    LoadFromFile('Input.bmp');
    SaveAsPPM('Output.ppm');
    Free;
  end;
end.
