procedure ShowTrigFunctions(Memo: TMemo);
const AngleDeg = 45.0;
var AngleRad,ArcSine,ArcCosine,ArcTangent: double;
begin
AngleRad:=DegToRad(AngleDeg);

Memo.Lines.Add(Format('Angle:      Degrees: %3.5f   Radians: %3.6f',[AngleDeg,AngleRad]));
Memo.Lines.Add('-------------------------------------------------');
Memo.Lines.Add(Format('Sine:       Degrees: %3.6f   Radians: %3.6f',[sin(DegToRad(AngleDeg)),sin(AngleRad)]));
Memo.Lines.Add(Format('Cosine:     Degrees: %3.6f   Radians: %3.6f',[cos(DegToRad(AngleDeg)),cos(AngleRad)]));
Memo.Lines.Add(Format('Tangent:    Degrees: %3.6f   Radians: %3.6f',[tan(DegToRad(AngleDeg)),tan(AngleRad)]));
ArcSine:=ArcSin(Sin(AngleRad));
Memo.Lines.Add(Format('Arcsine:    Degrees: %3.6f   Radians: %3.6f',[DegToRad(ArcSine),ArcSine]));
ArcCosine:=ArcCos(cos(AngleRad));
Memo.Lines.Add(Format('Arccosine:  Degrees: %3.6f   Radians: %3.6f',[DegToRad(ArcCosine),ArcCosine]));
ArcTangent:=ArcTan(tan(AngleRad));
Memo.Lines.Add(Format('Arctangent: Degrees: %3.6f   Radians: %3.6f',[DegToRad(ArcTangent),ArcTangent]));
end;
