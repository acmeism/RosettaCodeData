*-----------------------------------------------------------
* Title      : 100Doors.X68
* Written by : G. A. Tippery
* Date       : 2014-01-17
* Description: Solves "100 Doors" problem, see: http://rosettacode.org/wiki/100_doors
* Notes      : Translated from C "Unoptimized" version, http://rosettacode.org/wiki/100_doors#unoptimized
*            : No optimizations done relative to C version; "for("-equivalent loops could be optimized.
*-----------------------------------------------------------

*
*   System-specific general console I/O macros (Sim68K, in this case)
*
PUTS    MACRO
    ** Print a null-terminated string w/o CRLF **
    ** Usage: PUTS stringaddress
    ** Returns with D0, A1 modified
        MOVEQ   #14,D0      ; task number 14 (display null string)
        LEA     \1,A1       ; address of string
        TRAP    #15         ; display it
        ENDM
*
PRINTN  MACRO
    ** Print decimal integer from number in register
    ** Usage: PRINTN register
    ** Returns with D0,D1 modified
        IFNC '\1','D1'      ;if some register other than D1
          MOVE.L \1,D1      ;put number to display in D1
        ENDC
        MOVE.B  #3,D0
        TRAP    #15         ;display number in D1
*
*   Generic constants
*
CR      EQU     13      ;ASCII Carriage Return
LF      EQU     10      ;ASCII Line Feed

*
*   Definitions specific to this program
*
*   Register usage:
*   D3 == pass (index)
*   D4 == door (index)
*   A2 == Doors array pointer
*
SIZE    EQU     100             ;Define a symbolic constant for # of doors

        ORG     $1000           ;Specify load address for program -- actual address system-specific
START:                          ; Execution starts here
        LEA     Doors,A2        ; make A2 point to Doors byte array
        MOVEQ   #0,D3
PassLoop:
        CMP     #SIZE,D3
        BCC     ExitPassLoop    ; Branch on Carry Clear - being used as Branch on Higher or Equal
        MOVE    D3,D4
DoorLoop:
        CMP     #SIZE,D4
        BCC     ExitDoorLoop
        NOT.B   0(A2,D4)
        ADD     D3,D4
        ADDQ    #1,D4
        BRA     DoorLoop
ExitDoorLoop:
        ADDQ    #1,D3
        BRA     PassLoop
ExitPassLoop:

* $28 = 40. bytes of code to this point. 32626 cycles so far.
*   At this point, the result exists as the 100 bytes starting at address Doors.
* To get output, we must use methods specific to the particular hardware, OS, or
* emulator system that the code is running on.  I use macros to "hide" some of the
* system-specific details; equivalent macros would be written for another system.

        MOVEQ   #0,D4
PrintLoop:
        CMP     #SIZE,D4
        BCC     ExitPrintLoop
        PUTS    DoorMsg1
        MOVE    D4,D1
        ADDQ    #1,D1           ; Convert index to 1-based instead of 0-based
        PRINTN  D1
        PUTS    DoorMsg2
        TST.B   0(A2,D4)        ; Is this door open (!= 0)?
        BNE     ItsOpen
        PUTS    DoorMsgC
        BRA     Next
ItsOpen:
        PUTS    DoorMsgO
Next:
        ADDQ    #1,D4
        BRA     PrintLoop
ExitPrintLoop:

*  What to do at end of program is also system-specific
        SIMHALT             ;Halt simulator
*
* $78 = 120. bytes of code to this point, but this will depend on how the I/O macros are actually written.
* Cycle count is nearly meaningless, as the I/O hardware and routines will dominate the timing.

*
*   Data memory usage
*
        ORG     $2000
Doors   DCB.B   SIZE,0      ;Reserve 100 bytes, prefilled with zeros

DoorMsg1 DC.B   'Door ',0
DoorMsg2 DC.B   ' is ',0
DoorMsgC DC.B   'closed',CR,LF,0
DoorMsgO DC.B   'open',CR,LF,0

        END     START       ;last line of source
