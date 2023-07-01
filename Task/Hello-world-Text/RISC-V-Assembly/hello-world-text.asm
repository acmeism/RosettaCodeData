.data
hello:
.string "Hello World!\n\0"
.text
main:
la a0, hello
li a7, 4
ecall
li a7, 10
ecall
