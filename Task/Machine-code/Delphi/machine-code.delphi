function AddNumbers(Num1, Num2: integer): Integer;
{Add two numbers in assembly language}
asm
        PUSH    EBX
        PUSH    EDX
        MOV     ECX,Num1
        MOV     EDX,Num2
        ADD	ECX,EDX
        MOV	Result,ECX
        POP     EDX
        POP     EBX
end;



procedure TestAssembly(Memo: TMemo);
var I,J,K: integer;
begin
for I:=1 to 5 do
 for J:=1 to 5 do
	begin
	K:=AddNumbers(I,J);
	Memo.Lines.Add(IntToStr(I)+' + '+IntToStr(J)+' = '+IntToStr(K));
	end;
end;
