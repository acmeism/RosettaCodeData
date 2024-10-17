unit Unit1;

interface

uses
  Windows, SysUtils, Graphics, Forms, Controls, Classes, ExtCtrls;

type
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure CreateFern(const w, h: integer);
var r, x, y: double;
    tmpx, tmpy: double;
    i: integer;
begin
    x := 0;
    y := 0;
    randomize();

    for i := 0 to 200000 do begin
        r := random(100000000) / 99999989;
        if r <= 0.01 then begin
            tmpx := 0;
            tmpy := 0.16 * y;
        end
        else if r <= 0.08 then begin
            tmpx := 0.2 * x - 0.26 * y;
            tmpy := 0.23 * x + 0.22 * y + 1.6;
        end
        else if r <= 0.15 then begin
            tmpx := -0.15 * x + 0.28 * y;
            tmpy := 0.26 * x + 0.24 * y + 0.44;
        end
        else begin
            tmpx := 0.85 * x + 0.04 * y;
            tmpy := -0.04 * x + 0.85 * y + 1.6;
        end;
        x := tmpx;
        y := tmpy;

        Form1.PaintBox1.Canvas.Pixels[round(w / 2 + x * w / 11), round(h - y * h / 11)] := clGreen;
    end;
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
    CreateFern(Form1.ClientWidth, Form1.ClientHeight);
end;

end.
