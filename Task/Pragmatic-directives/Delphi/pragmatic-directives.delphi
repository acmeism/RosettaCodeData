// Some examples

{$R *.dfm}

{$R WorldMaps.res}

{$optimization on,hints off}

{$B+}
{$R- Turn off range checking}
{$I TYPES.INC}
{$M 32768,40960}
{$DEFINE Debug}
{$IFDEF Debug}
{$ENDIF}


 procedure DivMod(Dividend: Cardinal; Divisor: Word;
   var Result, Remainder: Word);
 {$IFDEF PUREPASCAL}
 begin
   Result := Dividend div Divisor;
   Remainder := Dividend mod Divisor;
 end;
 {$ELSE !PUREPASCAL}
 {$IFDEF X86ASM}
 asm // StackAlignSafe
         PUSH    EBX
         MOV     EBX,EDX
         MOV     EDX,EAX
         SHR     EDX,16
         DIV     BX
         MOV     EBX,Remainder
         MOV     [ECX],AX
         MOV     [EBX],DX
         POP     EBX
 end;
 {$ENDIF X86ASM}
 {$ENDIF !PUREPASCAL}
