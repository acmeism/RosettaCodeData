__Dmain
    push EAX
    mov  EAX,offset FLAT:_DATA
    push 0
    push 0375F00h
    push EAX
    call near ptr _printf
    add  ESP,0Ch
    xor  EAX,EAX
    pop  ECX
    ret
