  ;assumes memory at $02xx is initially set to 0 and stack pointer is initialized
  ;the 1 to 100 door byte array will be at $0200-$0263 (decimal 512 to 611)
  ;Zero-page location $01 will hold delta
  ;At end, closed doors = $00, open doors = $01

start:    ldx #0        ;initialize index - first door will be at $200 + $0
          stx $1
          inc $1        ;start out with a delta of 1 (0+1=1)
openloop: inc $200,X    ;open X'th door
          inc $1        ;add 2 to delta
          inc $1
          txa           ;add delta to X by transferring X to A, adding delta to A, then transferring back to X
          clc           ;  clear carry before adding (6502 has no add-without-carry instruction)
          adc $1
          tax
          cpx #$64      ;check to see if we're at or past the 100th door (at $200 + $63)
          bmi openloop  ;jump back to openloop if less than 100
