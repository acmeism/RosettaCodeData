rotr:
        movl    4(%esp), %eax        ; arg1: x
        movl    8(%esp), %ecx        ; arg2: s
        rorl    %cl, %eax            ; right rotate x by s
        ret
