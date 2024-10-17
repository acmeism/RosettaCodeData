unit Main;

interface

uses
  Winapi.Windows, System.SysUtils, Vcl.Forms, Vcl.Graphics, Vcl.Controls,
  System.Classes, Vcl.ExtCtrls;

type
  TfmNoise = class(TForm)
    tmr1sec: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure tmr1secTimer(Sender: TObject);
  end;

var
  fmNoise: TfmNoise;
  Surface: TBitmap;
  FrameCount: Cardinal = 0;

implementation

{$R *.dfm}

procedure TfmNoise.FormCreate(Sender: TObject);
begin
  Surface := TBitmap.Create;
  Surface.SetSize(320, 240);
  Surface.PixelFormat := pf1bit;
  Randomize;
end;

procedure TfmNoise.FormDestroy(Sender: TObject);
begin
  Surface.Free;
end;

type
  PDWordArray = ^TDWordArray;

  TDWordArray = array[0..16383] of DWord;

procedure TfmNoise.FormPaint(Sender: TObject);
var
  x, y: Integer;
  line: PWordArray;
begin
  with Surface do
    for y := 0 to Height - 1 do
    begin
      line := Surface.ScanLine[y];
      for x := 0 to (Width div 16) - 1 do
        line[x] := Random($FFFF);
      // Fill 16 pixels at same time
    end;

  Canvas.Draw(0, 0, Surface);
  Inc(FrameCount);
  Application.ProcessMessages;
  Invalidate;
end;

procedure TfmNoise.tmr1secTimer(Sender: TObject);
begin
  Caption := 'FPS: ' + FrameCount.ToString;
  FrameCount := 0;
end;

end.
