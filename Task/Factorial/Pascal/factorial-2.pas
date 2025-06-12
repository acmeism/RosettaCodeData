{$mode objFPC}{R+}
FUNCTION Fact(n: qword): qword;

VAR
    F: qword;

BEGIN
    if n > 20 then
    begin
        WriteLn('This function is only accurate up to 20!');
        exit(0);
    end;

    asm
        (*) Initialize result = 1 (0! = 1 case handled automatically) (*)

        mov     $1, %rax          (*)  RAX = 1 (initial result)       (*)
        mov      n, %rcx          (*)  RCX = input number (counter)   (*)

        test    %rcx, %rcx        (*)  Check if n=0                   (*)
        jz      .Lstore_result    (*)  Skip loop if n=0               (*)

    .Lloop1:
        imul    %rcx, %rax        (*)  RAX = RAX * RCX (signed mul)   (*)
        dec     %rcx              (*)  Decrement RCX                  (*)
        jnz     .Lloop1           (*)  Loop while RCX != 0            (*)

    .Lstore_result:
        mov     %rax, F           (*)  Store result in F              (*)
    end ['rax', 'rcx'];           (*)  Tell compiler register change  (*)

    Result := F;

END;


var
    N       : integer = 20 ;

begin

    writeln;
    writeln( BasicFact(N));

end.        (*)    Function Fact    (*)
