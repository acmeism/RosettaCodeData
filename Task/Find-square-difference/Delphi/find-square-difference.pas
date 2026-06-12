procedure LeastSquareDiff(Memo: TMemo; Limit: integer);
var N: integer;
var S: string;
begin
for N:=1 to High(integer) do
  if (N*N)-((N-1)*(N-1))>Limit then break;
S:=Format('Smallest Difference N^2: <%12d is: %12d',[Limit,N]);
Memo.Lines.Add(S);
end;


procedure ShowLeastSquareDiff(Memo: TMemo);
begin
LeastSquareDiff(Memo,1000);
LeastSquareDiff(Memo,32000);
LeastSquareDiff(Memo,2000000000);
end;

