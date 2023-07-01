type TCircle = record
 X,Y: double;
 R: double;
 end;


const Circles: array [0..24] of TCircle =(
(X: 1.6417233788; Y: 1.6121789534; R: 0.0848270516),
(X: -1.4944608174; Y: 1.2077959613; R: 1.1039549836),
(X: 0.6110294452; Y: -0.6907087527; R: 0.9089162485),
(X: 0.3844862411; Y: 0.2923344616; R: 0.2375743054),
(X: -0.2495892950; Y: -0.3832854473; R: 1.0845181219),
(X: 1.7813504266; Y: 1.6178237031; R: 0.8162655711),
(X: -0.1985249206; Y: -0.8343333301; R: 0.0538864941),
(X: -1.7011985145; Y: -0.1263820964; R: 0.4776976918),
(X: -0.4319462812; Y: 1.4104420482; R: 0.7886291537),
(X: 0.2178372997; Y: -0.9499557344; R: 0.0357871187),
(X: -0.6294854565; Y: -1.3078893852; R: 0.7653357688),
(X: 1.7952608455; Y: 0.6281269104; R: 0.2727652452),
(X: 1.4168575317; Y: 1.0683357171; R: 1.1016025378),
(X: 1.4637371396; Y: 0.9463877418; R: 1.1846214562),
(X: -0.5263668798; Y: 1.7315156631; R: 1.4428514068),
(X: -1.2197352481; Y: 0.9144146579; R: 1.0727263474),
(X: -0.1389358881; Y: 0.1092805780; R: 0.7350208828),
(X: 1.5293954595; Y: 0.0030278255; R: 1.2472867347),
(X: -0.5258728625; Y: 1.3782633069; R: 1.3495508831),
(X: -0.1403562064; Y: 0.2437382535; R: 1.3804956588),
(X: 0.8055826339; Y: -0.0482092025; R: 0.3327165165),
(X: -0.6311979224; Y: 0.7184578971; R: 0.2491045282),
(X: 1.4685857879; Y: -0.8347049536; R: 1.3670667538),
(X: -0.6855727502; Y: 1.6465021616; R: 1.0593087096),
(X: 0.0152957411; Y: 0.0638919221; R: 0.9771215985)
);


procedure CalculateCircleArea(Memo: TMemo; BoxPoints: integer = 500);
var MinX,MinY,MaxX,MaxY,Area: double;
var X,Y,BoxScaleX,BoxScaleY: double;
var I,Row,Col,Count: integer;
var Circle: TCircle;
begin
{Get minimum and maximum size of all the circles}
MinX:=MaxDouble; MinY:=MaxDouble;
MaxX:=MinDouble; MaxY:=MinDouble;
for I:=0 to High(Circles) do
	begin
	Circle:=Circles[I];
	MinX:=min(MinX,Circle.X - Circle.R);
	MaxX:=max(MaxX,Circle.X + Circle.R);
	MinY:=min(MinY,Circle.Y - Circle.R);
	MaxY:=max(MaxY,Circle.Y + Circle.R);
	end;
{Calculate scaling factor for X/Y dimension of box}
BoxScaleX:=(MaxX - MinX) / BoxPoints;
BoxScaleY:=(MaxY - MinY) / BoxPoints;
Count:=0;
{Iterate through all X/Y BoxPoints}
for Row:=0 to BoxPoints-1 do
	begin
	{Get scaled and offset Y pos}
	Y:=MinY + Row * BoxScaleY;
	for Col:=0 to BoxPoints-1 do
		begin
		{Get scaled and offset X pos}
		X:=MinX + Col * BoxScaleX;
		for I:=0 to High(Circles) do
			begin
			Circle:=Circles[I];
			{Check to see if point is in circle}
			if (sqr(X - Circle.X) + sqr(Y - Circle.Y)) <= (Sqr(Circle.R)) then
				begin
				Inc(Count);
				{Only count one circle}
				break;
				end;
			end;
		end;
	end;
{Calculate area from the box scale}
Area:=Count * BoxScaleX * BoxScaleY;
{Display it}
Memo.Lines.Add(Format('Side: %5d Points: %9.0n Area: %3.18f',[BoxPoints,BoxPoints*BoxPoints+0.0,Area]));
end;



procedure TotalCirclesArea(Memo: TMemo);
begin
CalculateCircleArea(Memo, 500);
CalculateCircleArea(Memo, 1000);
CalculateCircleArea(Memo, 1500);
CalculateCircleArea(Memo, 5000);
end;
