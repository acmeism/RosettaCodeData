main: { (('a' 'b' 'c')('A' 'B' 'C')('1' '2' '3'))
simul_array }

simul_array!:
    {{ dup
        { car << } each
        cdrall }
        { allnil? not }
    while }

cdrall!: { { { cdr } each -1 take } nest }

-- only returns true if all elements of a list are nil
allnil?!:
    { 1 <->
    { car nil?
        { zap 0 last }
        { nil }
    if} each }
