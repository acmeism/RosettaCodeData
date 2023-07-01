fourBitsAdder:
    pushl       %ebp
    movl        %esp,   %ebp
    andl        $-32,   %esp
    subl        $32,    %esp
    vmovaps 136(%ebp),  %ymm4
    vxorps      %ymm3,  %ymm4, %ymm5
    movl     20(%ebp),  %ecx
    vmovaps     %ymm5, (%ecx)
    vandps      %ymm3,  %ymm4, %ymm3
    vmovaps 104(%ebp),  %ymm4
    vxorps      %ymm2,  %ymm4, %ymm5
    vxorps      %ymm3,  %ymm5, %ymm6
    movl     16(%ebp),  %ecx
    vmovaps     %ymm6, (%ecx)
    vandps      %ymm3,  %ymm5, %ymm3
    vandps      %ymm2,  %ymm4, %ymm2
    vorps       %ymm2,  %ymm3, %ymm2
    vmovaps  72(%ebp),  %ymm3
    vxorps      %ymm1,  %ymm3, %ymm4
    vxorps      %ymm2,  %ymm4, %ymm5
    movl     12(%ebp),  %ecx
    vmovaps    %ymm5,  (%ecx)
    vandps      %ymm2,  %ymm4, %ymm2
    vandps      %ymm1,  %ymm3, %ymm1
    vorps       %ymm1,  %ymm2, %ymm1
    vmovaps  40(%ebp),  %ymm2
    vxorps      %ymm0,  %ymm2, %ymm3
    vxorps      %ymm1,  %ymm3, %ymm4
    movl      8(%ebp),  %ecx
    vmovaps     %ymm4, (%ecx)
    vandps      %ymm1,  %ymm3, %ymm1
    vandps      %ymm0,  %ymm2, %ymm0
    vorps       %ymm0,  %ymm1, %ymm0
    vmovaps     %ymm0, (%eax)
    movl        %ebp,   %esp
    popl        %ebp
    vzeroupper
    ret         $160
