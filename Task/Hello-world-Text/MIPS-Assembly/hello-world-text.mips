   .data #section for declaring variables
hello:  .asciiz "Hello world!" #asciiz automatically adds the null terminator. If it's .ascii it doesn't have it.

   .text # beginning of code
main: # a label, which can be used with jump and branching instructions.
   la $a0, hello # load the address of hello into $a0
   li $v0, 4 # set the syscall to print the string at the address $a0
   syscall # make the system call

   li $v0, 10 # set the syscall to exit
   syscall # make the system call
