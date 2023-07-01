unit Colour_barsDisplay;

interface

uses
  Winapi.Windows,  System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms;

type
  TfmColourBar = class(TForm)
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmColourBar: TfmColourBar;
  Colors: array of TColor = [clblack, clred, clgreen, clblue, clFuchsia, clAqua,
    clyellow, clwhite];

implementation

{$R *.dfm}

procedure TfmColourBar.FormPaint(Sender: TObject);
var
  w, h, i: Integer;
  r: TRect;
begin
  w := ClientWidth div length(Colors);
  h := ClientHeight;
  r := Rect(0, 0, w, h);

  with Canvas do
    for i := 0 to High(Colors) do
    begin
      Brush.Color := Colors[i];
      FillRect(r);
      r.Offset(w, 0);
    end;
end;

procedure TfmColourBar.FormResize(Sender: TObject);
begin
 Invalidate;
end;
end.
