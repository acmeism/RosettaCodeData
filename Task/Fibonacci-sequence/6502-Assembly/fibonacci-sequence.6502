       LDA  #0
       STA  $F0     ; LOWER NUMBER
       LDA  #1
       STA  $F1     ; HIGHER NUMBER
       LDX  #0
LOOP:  LDA  $F1
       STA  $0F1B,X
       STA  $F2     ; OLD HIGHER NUMBER
       ADC  $F0
       STA  $F1     ; NEW HIGHER NUMBER
       LDA  $F2
       STA  $F0     ; NEW LOWER NUMBER
       INX
       CPX  #$0A    ; STOP AT FIB(10)
       BMI  LOOP
       RTS          ; RETURN FROM SUBROUTINE
