begin
  var rad := Pi/3;
  var deg := RadToDeg(rad);
  Println('=== Radians ===');
  var (Si,Co,Ta) := (Sin(rad),Cos(rad),Tan(rad));
  Println($'Sin({rad}) = {Si}');
  Println($'Cos({rad}) = {Co}');
  Println($'Tan({rad}) = {Ta}');
  Println($'ArcSin({Si}) = {ArcSin(Si)}');
  Println($'ArcCos({Co}) = {ArcCos(Co)}');
  Println($'ArcTan({Ta}) = {ArcTan(Ta)}');
  Println('=== Degrees ===');
  var (SiD,CoD,TaD) := (Sin(DegToRad(deg)),Cos(DegToRad(deg)),Tan(DegToRad(deg)));
  Println($'Sin({deg}) = {SiD}');
  Println($'Cos({deg}) = {CoD}');
  Println($'Tan({deg}) = {TaD}');
  Println($'ArcSin({SiD}) = {RadToDeg(ArcSin(SiD))}');
  Println($'ArcCos({CoD}) = {RadToDeg(ArcCos(CoD))}');
  Println($'ArcTan({TaD}) = {RadToDeg(ArcTan(TaD))}');
end.
