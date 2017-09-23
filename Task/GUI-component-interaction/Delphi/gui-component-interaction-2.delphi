unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    EditInputField: TEdit;
    ButtonRandom: TButton;
    ButtonIncrement: TButton;
    procedure EditInputFieldChange(Sender: TObject);
    procedure ButtonIncrementClick(Sender: TObject);
    procedure ButtonRandomClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.EditInputFieldChange(Sender: TObject);
Var
  Value: Integer;
begin
   if not TryStrToInt(EditInputField.Text, value) then
  begin
     ShowMessage('Error! The Input Value is not numeric!');
      EditInputField.Text := '0';
   end;
end;

procedure TForm1.ButtonIncrementClick(Sender: TObject);
begin
   EditInputField.text := IntToStr  (StrToInt(EditInputField.Text) + 1);
end;

procedure TForm1.ButtonRandomClick(Sender: TObject);
begin
   Randomize;
   EditInputField.Text := IntToStr(Random(High(Integer)));
end;

end.
