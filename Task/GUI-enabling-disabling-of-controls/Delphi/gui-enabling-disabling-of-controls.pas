type
  TForm1 = class(TForm)
    MaskEditValue: TMaskEdit; // Set Editmask on: "99;0; "
    SpeedButtonIncrement: TSpeedButton;
    SpeedButtonDecrement: TSpeedButton;
    procedure MaskEditValueChange(Sender: TObject);
    procedure SpeedButtonDecrementClick(Sender: TObject);
    procedure SpeedButtonIncrementClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

procedure TForm1.MaskEditValueChange(Sender: TObject);
begin
  TMaskEdit(Sender).Enabled := StrToIntDef(Trim(TMaskEdit(Sender).Text), 0) = 0;
  SpeedButtonIncrement.Enabled := StrToIntDef(Trim(TMaskEdit(Sender).Text), 0) < 10;
  SpeedButtonDecrement.Enabled := StrToIntDef(Trim(TMaskEdit(Sender).Text), 0) > 0;
end;

procedure TForm1.SpeedButtonDecrementClick(Sender: TObject);
begin
  MaskEditValue.Text := IntToStr(Pred(StrToIntDef(Trim(MaskEditValue.Text), 0)));
end;

procedure TForm1.SpeedButtonIncrementClick(Sender: TObject);
begin
  MaskEditValue.Text := IntToStr(Succ(StrToIntDef(Trim(MaskEditValue.Text), 0)));
end;
