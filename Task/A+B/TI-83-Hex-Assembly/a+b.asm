PROGRAM:APLUSB
:AsmPrgm
:
:EFC541 ; ZeroOP1
:217984 ; ld hl,op1+1
:3641   ; ld (hl),'A'
:EFE34A ; RclVarSym
:CF     ; rst OP1toOP2
:
:EFC541 ; ZeroOP1
:217984 ; ld hl,op1+1
:3642   ; ld (hl),'B'
:EFE34A ; RclVarSym
:
:F7     ; rst FPAdd
:EFBF4A ; StoAns
:C9     ; ret
