type TIntArray = array of integer;

procedure GetJosephusSequence(N,K: integer; var IA: TIntArray);
{Analyze sequence of deleting every K of N numbers}
{Retrun result in Integer Array}
var LS: TList;
var I,J: integer;
begin
SetLength(IA,N);
LS:=TList.Create;
try
{Store number 0..N-1 in list}
for I:=0 to N-1 do LS.Add(Pointer(I));
J:=0;
for I:=0 to N-1 do
	begin
	{Advance J by K-1 because iterms are deleted}
	{And wrapping around if it J exceed the count }
        J:=(J+K-1) mod LS.Count;
        {Caption the sequence}
        IA[I]:=Integer(LS[J]);
        {Delete (kill) one item}
        LS.Delete(J);
	end;
finally LS.Free; end;
end;

procedure ShowJosephusProblem(Memo: TMemo; N,K: integer);
{Analyze and display one Josephus Problem}
var IA: TIntArray;
var I: integer;
var S: string;
const CRLF = #$0D#$0A;
begin
GetJosephusSequence(N,K,IA);
S:='';
for I:=0 to High(IA) do
	begin
	if I>0 then S:=S+',';
	if (I mod 12)=11 then S:=S+CRLF+'           ';
	S:=S+IntToStr(IA[I]);
	end;
Memo.Lines.Add('N='+IntToStr(N)+' K='+IntToStr(K));
Memo.Lines.Add('Sequence: ['+S+']');
Memo.Lines.Add('Survivor: '+IntToStr(IA[High(IA)]));
Memo.Lines.Add('');
end;

procedure TestJosephusProblem(Memo: TMemo);
{Test suite of Josephus Problems}
begin
ShowJosephusProblem(Memo,5,2);
ShowJosephusProblem(Memo,41,3);
end;
