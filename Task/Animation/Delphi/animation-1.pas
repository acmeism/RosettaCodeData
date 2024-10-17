unit Main;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    lblAniText: TLabel;
    tmrAniFrame: TTimer;
    procedure lblAniTextClick(Sender: TObject);
    procedure tmrAniFrameTimer(Sender: TObject);
  end;

var
  Form1: TForm1;
  Reverse: boolean = false;

implementation

{$R *.dfm}

procedure TForm1.lblAniTextClick(Sender: TObject);
begin
  Reverse := not Reverse;
end;

function Shift(text: string; direction: boolean): string;
begin
  if direction then
    result := text[text.Length] + text.Substring(0, text.Length - 1)
  else
    result := text.Substring(1, text.Length) + text[1];
end;

procedure TForm1.tmrAniFrameTimer(Sender: TObject);
begin
  with lblAniText do
    Caption := Shift(Caption, Reverse);
end;
end.
