procedure ShowColorfulNumbers(Memo: TMemo);
var I,P,Cnt,OldCnt,Start,Stop: integer;
var S: string;
var Largest: integer;


	function IsColorful(N: integer): boolean;
	var IA: TIntegerDynArray;
	var PList: TList;
	var I,J,D,P: integer;
	begin
	PList:=TList.Create;
	try
	Result:=False;
	GetDigits(N,IA);
	{Number of digits at a time}
	for D:=1 to Length(IA) do
	 {For all digits in number}
	 for I:=High(IA) downto D-1 do
		begin
		P:=1;
		{Product of digits in a group}
		for J:=0 to D-1 do P:=P * IA[I-J];
		{Has it already been used}
		if PList.IndexOf(Pointer(P))>=0 then exit;
		{Store in list}
		PList.Add(Pointer(P));
		end;
	Result:=True;
	finally PList.Free; end;
	end;


begin
Cnt:=0; S:='';
Memo.Line.Add('Colorful Number less than 100');
for I:=0 to 100-1 do
 if IsColorful(I) then
 	begin
	Inc(Cnt);
	S:=S+Format('%7D',[I]);
	If (Cnt mod 5)=0 then S:=S+CRLF;
	end;
Memo.Lines.Add(S);
Memo.Lines.Add('Count = '+IntToStr(Cnt));
for Largest:=98765432 downto 1 do
 if IsColorful(Largest) then break;
Memo.Lines.Add('Largest Colorful Number = '+IntToStr(Largest));

Start:=0; Stop:=9;
Cnt:=0; OldCnt:=0;
for P:=1 to 8 do
	begin
	for I:=Start to Stop do
	 if IsColorful(I) then Inc(Cnt);
	Memo.Lines.Add(Format('Colorful Numbers from %10.0n to %10.0n: %5D', [Start+0.0,Stop+0.0,Cnt-OldCnt]));
	Start:=Stop+1;
	Stop:=(Start*10)-1;
	OldCnt:=Cnt;
	end;
for I:=Stop+1 to Largest do
 if IsColorful(I) then Inc(Cnt);
Memo.Lines.Add('Total All Colorful = '+IntToStr(Cnt));
end;
