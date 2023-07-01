cout=: 1!:2&(<'/proc/self/fd/1')
dl=: 6!:3
spin=: {{ while. do. for_ch. y do. dl x [ cout 8 u:ch,CR end. end. }} 9 u:"1 ]
