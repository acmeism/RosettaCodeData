type TEmployeeInfo = record
 Name,ID: string;
 Salary: double;
 Dept: string;
 end;

var EmployeeInfo: array [0..12] of TEmployeeInfo = (
	(Name: 'Tyler Bennett'; ID: 'E10297'; Salary: 32000; Dept: 'D101'),
	(Name: 'John Rappl'; ID: 'E21437'; Salary: 47000; Dept: 'D050'),
	(Name: 'George Woltman'; ID: 'E00127'; Salary: 53500; Dept: 'D101'),
	(Name: 'Adam Smith'; ID: 'E63535'; Salary: 18000; Dept: 'D202'),
	(Name: 'Claire Buckman'; ID: 'E39876'; Salary: 27800; Dept: 'D202'),
	(Name: 'David McClellan'; ID: 'E04242'; Salary: 41500; Dept: 'D101'),
	(Name: 'Rich Holcomb'; ID: 'E01234'; Salary: 49500; Dept: 'D202'),
	(Name: 'Nathan Adams'; ID: 'E41298'; Salary: 21900; Dept: 'D050'),
	(Name: 'Richard Potter'; ID: 'E43128'; Salary: 15900; Dept: 'D101'),
	(Name: 'David Motsinger'; ID: 'E27002'; Salary: 19250; Dept: 'D202'),
	(Name: 'Tim Sampair'; ID: 'E03033'; Salary: 27000; Dept: 'D101'),
	(Name: 'Kim Arlich'; ID: 'E10001'; Salary: 57000; Dept: 'D190'),
	(Name: 'Timothy Grove'; ID: 'E16398'; Salary: 29900; Dept: 'D190')
	);


function SalarySort(Item1, Item2: Pointer): Integer;
var Info1,Info2: TEmployeeInfo;
begin
Info1:=TEmployeeInfo(Item1^);
Info2:=TEmployeeInfo(Item2^);
Result:=AnsiCompareStr(Info1.Dept,Info2.Dept);
If Result=0 then Result:=Trunc(Info1.Salary-Info2.Salary);
end;

procedure ShowTopSalaries(Memo: TMemo);
var List: TList;
var Info: TEmployeeInfo;
var I: integer;
var S,OldDept: string;

	procedure NewDepartment(Name: string);
	begin
	Memo.Lines.Add('');
	Memo.Lines.Add('Department: '+Name);
	Memo.Lines.Add('Employee Name    Employee ID      Salary           Department');
	OldDept:=Name;
	end;


begin
List:=TList.Create;
try
for I:=0 to High(EmployeeInfo) do
 List.Add(@EmployeeInfo[I]);
List.Sort(SalarySort);
OldDept:='';
for I:=0 to List.Count-1 do
	begin
	Info:=TEmployeeInfo(List[I]^);
	if OldDept<>Info.Dept then NewDepartment(Info.Dept);
	S:=Format('%-18S %9S %11.0m %8S',[Info.Name,Info.ID,Info.Salary,Info.Dept]);
	Memo.Lines.Add(S);
	end;

finally List.Free; end;
end;
