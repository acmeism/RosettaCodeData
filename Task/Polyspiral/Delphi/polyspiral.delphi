procedure PolySpiral(Image: TImage);
var Step,Angle,LineLen,I: integer;
var X,Y,X1,Y1: double;
begin
AbortFlag:=False;
ClearImage(Image,clBlack);
Image.Canvas.Pen.Width:=1;
while true do
	begin
	Image.Canvas.Pen.Color:=clYellow;
	Step:=(Step + 5) mod 360;
	X:=Image.Width/2;
	Y:=Image.Height/2;

	LineLen:=5;
	angle:=Step;
	for I:=1 to 150 do
		begin
		X1:=X + LineLen*cos(DegToRad(angle));
		Y1:=Y + LineLen*sin(DegToRad(angle));
		Image.Canvas.MoveTo(Round(X),Round(Y));
		Image.Canvas.LIneTo(Round(X1),Round(Y1));
		Image.Repaint;

		LineLen:=LineLen+2;

		Angle:=(Angle + Step) mod 360;
		X:=X1;
		Y:=Y1;
		end;
	if Application.Terminated then exit;
	if AbortFlag then break;
	Sleep(1200);
	Application.ProcessMessages;
	WaitForButton;
	ClearImage(Image,clBlack);
	end;
end;
