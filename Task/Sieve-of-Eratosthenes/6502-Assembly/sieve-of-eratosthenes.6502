ERATOS: STA  $D0      ; value of n
        LDA  #$00
        LDX  #$00
SETUP:  STA  $1000,X  ; populate array
        ADC  #$01
        INX
        CPX  $D0
        BPL  SET
        JMP  SETUP
SET:    LDX  #$02
SIEVE:  LDA  $1000,X  ; find non-zero
        INX
        CPX  $D0
        BPL  SIEVED
        CMP  #$00
        BEQ  SIEVE
        STA  $D1      ; current prime
MARK:   CLC
        ADC  $D1
        TAY
        LDA  #$00
        STA  $1000,Y
        TYA
        CMP  $D0
        BPL  SIEVE
        JMP  MARK
SIEVED: LDX  #$01
        LDY  #$00
COPY:   INX
        CPX  $D0
        BPL  COPIED
        LDA  $1000,X
        CMP  #$00
        BEQ  COPY
        STA  $2000,Y
        INY
        JMP  COPY
COPIED: TYA           ; how many found
        RTS
