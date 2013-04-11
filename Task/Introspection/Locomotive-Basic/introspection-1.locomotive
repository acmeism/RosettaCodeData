org &4000   ; program start address

push bc
push de
push hl
push af
ld bc,&df00 ; select BASIC ROM
out (c),c   ;   (ROM 0)

ld bc,&7f86 ; make ROM accessible at &c000
out (c),c             ;   (RAM block 3)

ld hl,&c001 ; copy ROM version number to RAM
ld de,&4040
ld bc,3
ldir

ld bc,&7f8e ; turn off ROM
out (c),c
pop af
pop hl
pop de
pop bc
ret
