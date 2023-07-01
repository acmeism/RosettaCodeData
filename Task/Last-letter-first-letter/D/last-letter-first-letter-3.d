LBB0_4:
    movl (%esi), %eax
    movb 19(%esp), %cl
    cmpb %cl, (%eax)
jne LBB0_6
    movl (%edi,%ebx,4), %ecx
    movl %eax, (%edi,%ebx,4)
    movl %ecx, (%esi)
    movl %edi, 8(%esp)
    movl 48(%esp), %eax
    movl %eax, 4(%esp)
    movl 12(%esp), %eax
    movl %eax, (%esp)
    movl 20(%esp), %eax
    calll __D25last_letter_first_letter26searchFNaAPyaxiKAPyaZv
    subl $12, %esp
    movl (%edi,%ebx,4), %eax
    movl (%esi), %ecx
    movl %ecx, (%edi,%ebx,4)
    movl %eax, (%esi)
LBB0_6:
    addl $4, %esi
    decl %ebp
    jne LBB0_4
