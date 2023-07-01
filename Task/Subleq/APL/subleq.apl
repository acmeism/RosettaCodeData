#!/usr/local/bin/apl -s --
⎕IO←0                       ⍝ Index origin 0 is more intuitive with 'pointers'
∇Subleq;fn;text;M;A;B;C;X
        →(5≠⍴⎕ARG)/usage    ⍝ There should be one (additional) argument
        fn←⊃⎕ARG[4]         ⍝ This argument should be the file name
        →(''≢0⍴text←⎕FIO[26]fn)/filerr ⍝ Load the file
        text[(text∊⎕TC)/⍳⍴text]←' '    ⍝ Control characters to spaces
        text[(text='-')/⍳⍴text]←'¯'    ⍝ Negative numbers get high minus
        M←⍎text             ⍝ The memory starts with the numbers in the text
        pc←0                ⍝ Program counter starts at PC

instr:  (A B C)←3↑pc↓M        ⍝ Read instruction
        M←'(1+A⌈B⌈C⌈⍴M)↑M'⎕EA'M⊣M[A,B,C]' ⍝ Extend the array if necessary
        pc←pc+3               ⍝ PC is incremented by 3
        →(A=¯1)/in            ⍝ If A=-1, read input
        →(B=¯1)/out           ⍝ If B=-1, write output
        →(0<M[B]←M[B]-M[A])/instr   ⍝ Do SUBLEQ instruction
        pc←C                  ⍝ Set PC if necessary
        →(C≥0)×instr          ⍝ Next instruction if C≥0

in:     X←(M[B]←1⎕FIO[41]1)⎕FIO[42]1 ⋄ →instr
out:    X←M[A]⎕FIO[42]1 ⋄ →instr

usage:  'subleq.apl <file> - Run the SUBLEQ program in <file>' ⋄ →0
filerr: 'Error loading: ',fn ⋄ →0
∇

Subleq
)OFF
