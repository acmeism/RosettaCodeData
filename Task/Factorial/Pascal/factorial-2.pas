{$mode objFPC}{R+}
FUNCTION Factorial ( n : qword ) : qword;

    (*)
           Update for version 3.2.0
           Factorial works until 20! , which is good enough for me for now
           replace qword with dword and rax,rcx with eax, ecx for 32-bit
           for Factorial until 12!
    (*)

    VAR
	
	F:	qword;
	
    BEGIN

	asm
	
		mov		$1,	%rax
		mov		 n,	%rcx
		
	.Lloop1:
			imul	%rcx,	%rax
			loopnz	.Lloop1
		
		mov	%rax,   F

	end;

	Result := F ;
	
    END;
