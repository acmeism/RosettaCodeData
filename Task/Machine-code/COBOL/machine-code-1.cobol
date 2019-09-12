pushq	%rbp
movq	%rsp, %rbp
movl	%edi, -0x4(%rbp)
movl	%esi, -0x8(%rbp)
movl	-0x4(%rbp), %esi
addl	-0x8(%rbp), %esi
movl	%esi, -0xc(%rbp)
movl	-0xc(%rbp), %eax
popq	%rbp
retq
