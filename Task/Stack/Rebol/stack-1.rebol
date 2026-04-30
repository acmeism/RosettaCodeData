stack: copy []
append stack 1  ;== [1]
append stack 2  ;== [1 2]
take/last stack ;== 2
take/last stack ;== 1
empty? stack    ;== true
