; 100 DOORS in  6502 assembly language for: http://www.6502asm.com/beta/index.html
; Written for the original MOS Technology, Inc. NMOS version of the 6502, but should work with any version.
; Based on BASIC QB64 unoptimized version: http://rosettacode.org/wiki/100_doors#BASIC
;
; Notes:
;    Doors array[1..100] is at $0201..$0264. On the specified emulator, this is in video memory, so tbe results will
; be directly shown as pixels in the display.
;    $0200 (door 0) is cleared for display purposes but is not involved in the open/close loops.
;    Y register holds Stride
;    X register holds Index
;    Zero Page address $01 used to add Stride to Index (via A) because there's no add-to-X or add-Y-to-A instruction.

  ; First, zero door array
    LDA #00
    LDX #100
Z_LOOP:
    STA 200,X
    DEX
    BNE Z_LOOP
    STA 200,X

  ; Now do doors repeated open/close
    LDY #01        ; Initial value of Stride
S_LOOP:
    CPY #101
    BCS S_DONE
    TYA            ; Initial value of Index
I_LOOP:
    CMP #101
    BCS I_DONE
    TAX            ; Use as Door array index
    INC $200,X     ; Toggle bit 0 to reverse state of door
    STY 01         ; Add stride (Y) to index (X, via A)
    ADC 01
    BCC I_LOOP
I_DONE:
    INY
    BNE S_LOOP
S_DONE:

  ; Finally, format array values for output: 0 for closed, 1 for open
    LDX #100
C_LOOP:
    LDA $200,X
    AND #$01
    STA $200,X
    DEX
    BNE C_LOOP
