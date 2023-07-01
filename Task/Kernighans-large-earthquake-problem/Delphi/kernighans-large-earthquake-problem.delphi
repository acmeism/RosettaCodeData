{Structure used to contain all the earthquake data}

type TQuakeInfo = record
 Date: TDate;
 Name: string;
 Mag: double;
 end;
type PQuakeInfo = ^TQuakeInfo;

{Used to contain individual fields of the earthquake data}

type TStringArray = array of string;


function SortCompare(List: TStringList; Index1, Index2: Integer): Integer;
{Custom sort routine to sort data by magnitude }
var QI1,QI2: TQuakeInfo;
begin
QI1:=PQuakeInfo(List.Objects[Index1])^;
QI2:=PQuakeInfo(List.Objects[Index2])^;
Result:=Round(QI2.Mag*10)-Round(QI1.Mag*10);
end;

procedure GetFields(S: string; var SA: TStringArray);
{Extract the three fields from each row of data}
var I,F: integer;
begin
SetLength(SA,3);
for I:=0 to High(SA) do SA[I]:='';
F:=0;
for I:=1 to Length(S) do
 if S[I] in [#$09,#$20] then Inc(F)
 else SA[F]:=SA[F]+S[I];
end;

procedure AnalyzeEarthQuakes(Filename: string; Memo: TMemo);
{Read earhtquake data from specified file}
{Extract the individual fields and sort and display it}
var SL: TStringList;
var I: integer;
var S: string;
var FA: TStringArray;
var QI: PQuakeInfo;
begin
SL:=TStringList.Create;
try
{Read file, separating it into rows}
SL.LoadFromFile(Filename);
{Process each row}
for I:=0 to SL.Count-1 do
	begin
	S:=SL[I];
	{Separate row into fields}
	GetFields(S,FA);
	{Store data as objects in TStringList}
	New(QI);
	QI.Date:=StrToDate(FA[0]);
	QI.Name:=FA[1];
	QI.Mag:=StrToFloat(FA[2]);
	SL.Objects[I]:=TObject(QI);
	end;
{Sort data by magnitude}
SL.CustomSort(SortCompare);
{Display sorted data}
for I:=0 to SL.Count-1 do
	begin
	if PQuakeInfo(SL.Objects[I]).Mag<6 then break;
	S:=FormatDateTime('dd/mm/yyyy', PQuakeInfo(SL.Objects[I]).Date);
	S:=S+Format('  %-34s',[PQuakeInfo(SL.Objects[I]).Name]);
	S:=S+Format('  %5f',[PQuakeInfo(SL.Objects[I]).Mag]);
        Memo.Lines.Add(S);
	end;
{Dispose of memory}
finally
 for I:=0 to SL.Count-1 do Dispose(PQuakeInfo(SL.Objects[I]));
 SL.Free;
 end;
end;


procedure ShowEarthQuakes(Memo: TMemo);
begin
AnalyzeEarthQuakes('EarthQuakes.txt',Memo);
end;
