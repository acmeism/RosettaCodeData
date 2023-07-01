function AveSqrDiff(TrueVal: double; Data: array of double): double;
var I: integer;
begin
Result:=0;
for I:=0 to High(Data) do Result:=Result+Sqr(Data[I]-TrueVal);
Result:=Result/Length(Data);
end;

procedure DoDiversityPrediction(Memo: TMemo; TrueValue: double; Crowd: array of double);
var AveError,AvePredict,Diversity: double;
var S: string;
begin
AveError:=AveSqrDiff(Truevalue,Crowd);
AvePredict:=Mean(Crowd);
Diversity:=AveSqrDiff(AvePredict,Crowd);
S:='Ave Error: '+FloatToStrF(AveError,ffFixed,18,2)+#$0D#$0A;
S:=S+'Crowd Error: '+FloatToStrF(Sqr(TrueValue - AvePredict),ffFixed,18,2)+#$0D#$0A;
S:=S+'Diversity: '+FloatToStrF(Diversity,ffFixed,18,2)+#$0D#$0A;
Memo.Lines.Add(S);
end;

procedure ShowDiversityPrediction(Memo: TMemo);
begin
DoDiversityPrediction(Memo,49,[48,47,51]);
DoDiversityPrediction(Memo,49,[48,47,51,42]);
end;
