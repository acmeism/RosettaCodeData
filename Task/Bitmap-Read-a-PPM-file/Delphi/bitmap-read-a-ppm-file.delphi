program BtmAndPpm;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes,
  Winapi.Windows,
  Vcl.Graphics;

type
  TBitmapHelper = class helper for TBitmap
  private
  public
    procedure SaveAsPPM(FileName: TFileName; useGrayScale: Boolean = False);
    procedure LoadFromPPM(FileName: TFileName; useGrayScale: Boolean = False);
  end;

function ColorToGray(Color: TColor): TColor;
var
  L: Byte;
begin
  L := round(0.2126 * GetRValue(Color) + 0.7152 * GetGValue(Color) + 0.0722 *
    GetBValue(Color));
  Result := RGB(L, L, L);
end;

{ TBitmapHelper }

procedure TBitmapHelper.SaveAsPPM(FileName: TFileName; useGrayScale: Boolean = False);
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
        if useGrayScale then
          color := ColorToGray(ColorToRGB(Self.Canvas.Pixels[i, j]))
        else
          color := ColorToRGB(Self.Canvas.Pixels[i, j]);
        ppm.Write(color, 3);
      end;
    ppm.SaveToFile(FileName);
  finally
    ppm.Free;
  end;
end;

procedure TBitmapHelper.LoadFromPPM(FileName: TFileName; useGrayScale: Boolean = False);
var
  p: Integer;
  ppm: TMemoryStream;
  sW, sH: string;
  temp: AnsiChar;
  W, H: Integer;
  Color: TColor;

  function ReadChar: AnsiChar;
  begin
    ppm.Read(Result, 1);
  end;

begin
  ppm := TMemoryStream.Create;
  ppm.LoadFromFile(FileName);
  if ReadChar + ReadChar <> 'P6' then
    exit;

  repeat
    temp := ReadChar;
    if temp in ['0'..'9'] then
      sW := sW + temp;
  until temp = ' ';

  repeat
    temp := ReadChar;
    if temp in ['0'..'9'] then
      sH := sH + temp;
  until temp = #10;

  W := StrToInt(sW);
  H := StrToInt(sH);

  if ReadChar + ReadChar + ReadChar <> '255' then
    exit;

  ReadChar(); //skip newLine

  SetSize(W, H);
  p := 0;
  while ppm.Read(Color, 3) > 0 do
  begin
    if useGrayScale then
      Color := ColorToGray(Color);
    Canvas.Pixels[p mod W, p div W] := Color;
    inc(p);
  end;
  ppm.Free;
end;

begin
  with TBitmap.Create do
  begin
    // Load bmp
    LoadFromFile('Input.bmp');
    // Save as ppm
    SaveAsPPM('Output.ppm');

    // Load as ppm and convert in grayscale
    LoadFromPPM('Output.ppm', True);

    // Save as bmp
    SaveToFile('Output.bmp');

    Free;
  end;
end.
