.equ STDOUT, 1
.equ SVC_WRITE, 64
.equ SVC_EXIT, 93

.text
.global _start

_start:
	stp x29, x30, [sp, -16]!
	mov x0, #STDOUT
	ldr x1, =msg
	mov x2, 13
	mov x8, #SVC_WRITE
	mov x29, sp
	svc #0 // write(stdout, msg, 13);
	ldp x29, x30, [sp], 16
	mov x0, #0
	mov x8, #SVC_EXIT
	svc #0 // exit(0);

msg:	.ascii "Hello World!\n"
.align 4
