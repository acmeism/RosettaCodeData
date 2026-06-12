{Data type to hold difference info}

type TDiffInfo = record
 Diff,N1,N2: double;
 end;

{Array of different info}

type TDiffArray = array of TDiffInfo;

procedure FindMaximumDifference(List: array of double; var DiffArray: TDiffArray);
{Analyze data and return list of differnces}
var I: integer;
var Diff,MaxDiff: double;
begin
MaxDiff:=0;
for I:=0 to High(List)-1 do
	begin
	Diff:=Abs(List[I+1]-List[I]);
	if Diff>=MaxDiff then
		begin
		MaxDiff:=Diff;
		SetLength(DiffArray,Length(DiffArray)+1);
		DiffArray[High(DiffArray)].Diff:=MaxDiff;
		DiffArray[High(DiffArray)].N1:=List[I];
		DiffArray[High(DiffArray)].N2:=List[I+1];
		end
	end;
end;

procedure MaximumAdjacentDifference(Memo: TMemo);
var DA: TDiffArray;
var I: integer;
begin
FindMaximumDifference([1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3],DA);
for I:=0 to High(DA) do
	begin
	Memo.Lines.Add(Format('abs(%4.1f - %4.1f) = %4.1f',[DA[I].N1,DA[I].N2,DA[I].Diff]));
	end;
end;

