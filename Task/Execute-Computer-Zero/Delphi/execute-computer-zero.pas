{structure that holds name of program and code}

type TProgram = record
 Name, Code: string;
 end;

{List of programs}

var ProgList: array [0..4] of TProgram =(
	(Name: 'Two plus two'; Code: 'LDA 3 ADD 4 STP 2 2'),
	(Name: 'Seven times eight'; Code: 'LDA 12 ADD 10 STA 12 LDA 11 SUB 13 STA 11 BRZ 8 JMP 0 LDA 12 STP 8 7 0 1'),
	(Name: 'The Fibonacci sequence'; Code: 'LDA 14 STA 15 ADD 13 STA 14 LDA 15 STA 13 LDA 16 SUB 17 BRZ 11 STA 16 JMP 0 LDA 14 STP 1 1 0 8 1'),
	(Name: 'Linked list'; Code: 'LDA 13 ADD 15 STA 5 ADD 16 STA 7 NOP STA 14 NOP BRZ 11 STA 15 JMP 0 LDA 14 STP LDA 0 0 28 1 0 0 0 6 0 2 26 5 20 3 30 1 22 4 24'),
	(Name: 'Prisoner’s Dilemma'; Code: '0 0 STP NOP LDA 3 SUB 29 BRZ 18 LDA 3 STA 29 BRZ 14 LDA 1 ADD 31 STA 1 JMP 2 LDA 0 ADD 31 STA 0 JMP 2 LDA 3 STA 29 LDA 0 ADD 30 ADD 3 STA 0 LDA 1 ADD 30 ADD 3 STA 1 JMP 2 0 1 3')
	);

{Defines opcode function call}

type TOpProc = function(Opcode: byte): boolean;

{Defines argument type for opcode}

type TArgType = (atNone,atAddress,atMemory);

{Defines Opcode information}

type TOpcode = record
 OpCode: integer;
 ArgType: TArgType;
 Mnemonic: string[3];
 Proc: TOpProc;
 end;

{Simulated memory, program counter and accumulator}

var Memory: array [0..31] of byte;
var ProgramCounter: integer;
var Accumulator: byte;

{Routines to carry out actions of opcodes}

function DoNoOp(Operand: byte): boolean;
{ ($00) = NOP     - (no operation)}
begin
Inc(ProgramCounter);
Result:=True;
end;


function DoLDA(Operand: byte): boolean;
{ ($20)   LDA - (load accumulator) - a := memory [xxxxx]}
begin
Accumulator:=Memory[Operand];
Inc(ProgramCounter);
Result:=True;
end;


function DoSTA(Operand: byte): boolean;
{ ($40)   STA - (store accumulator)       - memory [xxxxx] := a}
begin
Memory[Operand]:=Accumulator;
Inc(ProgramCounter);
Result:=True;
end;


function DoADD(Operand: byte): boolean;
{ ($60)   ADD - (add) - a := a + memory [xxxxx]}
begin
Accumulator:=Accumulator + Memory[Operand];
Inc(ProgramCounter);
Result:=True;
end;


function DoSUB(Operand: byte): boolean;
{ ($80)   SUB - (subtract) - a := a – memory [xxxxx]}
begin
Accumulator:=Accumulator - Memory[Operand];
Inc(ProgramCounter);
Result:=True;
end;


function DoBRZ(Operand: byte): boolean;
{ ($A0)   BRZ - (branch on zero) - if a = 0 then goto xxxxx}
begin
if Accumulator=0 then ProgramCounter:=Operand
else Inc(ProgramCounter);
Result:=True;
end;


function DoJMP(Operand: byte): boolean;
{ ($C0)   JMP - (jump) - goto xxxxx}
begin
ProgramCounter:=Operand;
Result:=True;
end;


function DoSTP(Operand: byte): boolean;
{ ($E0)   STP - (stop)}
begin
Result:=False;
end;

{Table of opcodes}

var OpTable: array [0..7] of TOpcode= (
	(Opcode: $00; ArgType: atNone; Mnemonic: 'NOP'; Proc: DoNoOp),
	(Opcode: $20; ArgType: atMemory; Mnemonic: 'LDA'; Proc: DoLDA),
	(Opcode: $40; ArgType: atMemory; Mnemonic: 'STA'; Proc: DoSTA),
	(Opcode: $60; ArgType: atMemory; Mnemonic: 'ADD'; Proc: DoADD),
	(Opcode: $80; ArgType: atMemory; Mnemonic: 'SUB'; Proc: DoSUB),
	(Opcode: $A0; ArgType: atAddress; Mnemonic: 'BRZ'; Proc: DoBRZ),
	(Opcode: $C0; ArgType: atAddress; Mnemonic: 'JMP'; Proc: DoJMP),
	(Opcode: $E0; ArgType: atNone; Mnemonic: 'STP'; Proc: DoSTP));



procedure ClearMemory;
{Set all memory locations to zero}
var I: integer;
begin
for I:=0 to High(Memory) do
 Memory[I]:=0;
end;


function DecodeMnemonic(NMem: string): TOpcode;
{Convert 3-char Mnemonic to opcode info}
var I: integer;
begin
for I:=0 to High(OpTable) do
 if NMem=OpTable[I].Mnemonic then
	begin
	Result:=OpTable[I];
	exit;
	end;
raise Exception.Create('Opcode Not Found');
end;


procedure AssembleProgram(Prog: string);
{Convert text source code into machine code and store in memory}
var Inx,MemInx,IntAtom,T: integer;
var Atom: string;
var OC: TOpcode;
begin
ClearMemory;
MemInx:=0;
Inx:=1;
while true do
	begin
	{Get one space delimited atom}
	Atom:=ExtractToken(Prog,' ',Inx);
	{exit if end of source code}
	if Atom='' then break;
	{Is the atom text (Mnemonic) or number?}
	if Atom[1] in ['A'..'Z','a'..'z'] then
		begin
		{Convert Mnemonic to opcode info}
		OC:=DecodeMnemonic(Atom);
		{Get machine value of opcode}
		IntAtom:=OC.OpCode;
		{Is operand of of memory or address type?}
		if OC.ArgType in [atMemory,atAddress] then
			begin
			{if so combine opcode and operand}
                        Atom:=ExtractToken(Prog,' ',Inx);
                        T:=StrToInt(Atom);
                        IntAtom:=IntAtom or T;
			end;
		end
	else IntAtom:=StrToInt(Atom);
	{Store machine code in memory}
	Memory[MemInx]:=IntAtom;
	{Point to next memory location}
	Inc(MemInx);
	end;
end;


function DecodeOpcode(Inst: byte; var Opcode: TOpcode): boolean;
{Convert machine instruction to opcode information}
var I: integer;
var Op: byte;
begin
Result:=True;
{Get opcode part of instruction}
Op:=$E0 and Inst;
{Look for it in table}
for I:=0 to High(OpTable) do
 if OpTable[I].OpCode=Op then
	begin
	Opcode:=OpTable[I];
	exit;
	end;
Result:=False;
end;


function ExecuteInstruction(Instruct: byte): boolean;
{Execute a single instruction}
var I: integer;
var Opcode: TOpcode;
var Operand: byte;
begin
if not DecodeOpcode(Instruct,Opcode) then raise Exception.Create('Illegal Opcode');
{Separate instruction and operand}
Operand:=$1F and Instruct;
{Execute instruction}
Result:=Opcode.Proc(Operand);
end;


procedure DisplayInstruction(Memo: TMemo; PC: integer);
{Display instruction information}
var Opcode: TOpcode;
var Inst,Operand: integer;
var S: string;
begin
Inst:=Memory[PC];
if not DecodeOpcode(Inst,Opcode) then raise Exception.Create('Illegal Opcode');
Operand:=Inst and $1F;
S:=IntToStr(PC)+' $'+IntToHex(Inst,2);
S:=S+'  '+Opcode.Mnemonic;
case Opcode.ArgType of
 atMemory:
	begin
	S:=S+'  Mem['+IntToStr(Operand)+']=';
	S:=S+'  '+IntToStr(Memory[Operand]);
	end;
 atAddress: S:=S+'  '+IntToStr(Operand);
 end;
Memo.Lines.Add(S);
end;


procedure ExecuteProgram(Memo: TMemo; Prog: TProgram);
{Executed program until stop instruction reached}
begin
Memo.Lines.Add(Prog.Name);
AssembleProgram(Prog.Code);
ProgramCounter:=0;
Accumulator:=0;
repeat
	begin
	DisplayInstruction(Memo,ProgramCounter);
	end
until not ExecuteInstruction(Memory[ProgramCounter]);
Memo.Lines.Add('Result='+IntToStr(Accumulator));
Memo.Lines.Add('');
end;



procedure ShowComputerZero(Memo: TMemo);
{Execute and display all five sample programs.}
begin
ExecuteProgram(Memo,ProgList[0]);
ExecuteProgram(Memo,ProgList[1]);
ExecuteProgram(Memo,ProgList[2]);
ExecuteProgram(Memo,ProgList[3]);
ExecuteProgram(Memo,ProgList[4]);
end;
