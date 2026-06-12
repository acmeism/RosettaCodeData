{Define structure to contain triple}

type TTriple = record
 A, B, C: integer;
 end;

{Make dynamic array of triples}

type TTripleArray = array of TTriple;

procedure PythagorianTriples(Limit: integer; var TA: TTripleArray);
{Find pythagorian Triple up to limit - Return result in list TA}
var Limit2: integer;
var I,J,K: integer;
begin
SetLength(TA,0);
Limit2:=Limit div 2;
for I:=1 to Limit2 do
 for J:=I to Limit2 do
 for K:=J to Limit do
  if ((I+J+K)<Limit) and ((I*I+J*J)=(K*K)) then
	begin
	SetLength(TA,Length(TA)+1);
	TA[High(TA)].A:=I;
	TA[High(TA)].B:=J;
	TA[High(TA)].C:=K;
	end;
end;


procedure ShowPythagoreanTriplet(Memo: TMemo);
var TA: TTripleArray;
var I, Sum, Prod: integer;
begin
{Find triples up to 1100}
PythagorianTriples(1100,TA);
for I:=0 to High(TA) do
	begin
	{Look for sum of 1000}
	Sum:=TA[I].A + TA[I].B + TA[I].C;
	if Sum<>1000 then continue;
	{Display result}
	Prod:=TA[I].A * TA[I].B * TA[I].C;
	Memo.Lines.Add(Format('%d + %d + %d = %10.0n',[TA[I].A, TA[I].B, TA[I].C, Sum+0.0]));
	Memo.Lines.Add(Format('%d * %d * %d = %10.0n',[TA[I].A, TA[I].B, TA[I].C, Prod+0.0]));
	end;
end;

