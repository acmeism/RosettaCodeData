// The project file (Project1.dpr)
program Project1;

uses
  Forms,
  // Include file with Window class declaration (see below)
  Unit0 in 'Unit1.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.


// The Window class declaration
unit Unit1;

interface

uses
  Forms;

type
  TForm1 = class(TForm)
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm} // The window definition resource (see below)

end.

// A textual rendition of the Window (form) definition file (Unit1.dfm)
object Form1: TForm1
  Left = 469
  Top = 142
  Width = 800
  Height = 600
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
end
