unit Form_SumOfASeries_Unit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormSumOfASeries = class(TForm)
    M_Log: TMemo;
    B_Calc: TButton;
    procedure B_CalcClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  FormSumOfASeries: TFormSumOfASeries;

implementation

{$R *.dfm}

function Sum_Of_A_Series(_from,_to:int64):extended;
begin
  result:=0;
  while _from<=_to do
  begin
    result:=result+1.0/(_from*_from);
    inc(_from);
  end;
end;

procedure TFormSumOfASeries.B_CalcClick(Sender: TObject);
begin
  try
    M_Log.Lines.Add(FloatToStr(Sum_Of_A_Series(1, 1000)));
  except
    M_Log.Lines.Add('Error');
  end;
end;

end.
