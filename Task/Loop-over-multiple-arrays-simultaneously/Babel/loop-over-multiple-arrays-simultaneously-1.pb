main: { (('a' 'b' 'c')('A' 'B' 'C')('1' '2' '3'))
simul_array }

simul_array!:
    { trans
    { { << } each "\n" << } each }
