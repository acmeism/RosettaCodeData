push 1024

0:
    dup onum push 10 ochr
    push 2 div dup
    push 0 swap sub
        jn 0
        pop exit
