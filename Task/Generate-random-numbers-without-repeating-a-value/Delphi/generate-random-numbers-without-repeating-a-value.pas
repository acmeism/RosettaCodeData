{Create randomize object to make it easier to use}

type TRandomizer = class(TObject)
 private
  FSize: integer;
  procedure SetSize(const Value: integer);
 protected
  procedure Randomize;
 public
  Numbers: array of Integer;
  constructor Create;
  property Size: integer read FSize write SetSize;
 end;

{ TRandomizer }

constructor TRandomizer.Create;
begin
Size:=20;
end;

procedure TRandomizer.Randomize;
var I,Inx1,Inx2,T: integer;
begin
for I:=1 to 100 do
	begin
	Inx1:=Random(Length(Numbers));
	Inx2:=Random(Length(Numbers));
	T:=Numbers[Inx1];
	Numbers[Inx1]:=Numbers[Inx2];
	Numbers[Inx2]:=T;
	end;

end;

procedure TRandomizer.SetSize(const Value: integer);
var I: integer;
begin
if FSize<>Value then
	begin
	FSize:=Value;
	SetLength(Numbers,FSize);
	for I:=0 to FSize-1 do Numbers[I]:=I+1;
	Randomize;
	end;
end;

{------------------------------------------------------------------------------}

procedure ShowRandomNumbers(Memo: TMemo);
var RD: TRandomizer;
var S: string;
var I,J: integer;
begin
RD:=TRandomizer.Create;
try
RD.Size:=20;
for J:=1 to 5 do
	begin
	RD.Randomize;
	S:='[';
	for I:=0 to High(RD.Numbers) do
	   S:=S+Format('%3D',[RD.Numbers[I]]);
	S:=S+']';
	Memo.Lines.Add(S);
	end;
finally RD.Free; end;
end;


