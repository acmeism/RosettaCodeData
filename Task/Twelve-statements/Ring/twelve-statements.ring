nStatements = 12
T    = list(nStatements)
Pass = list(nStatements)

for tryVal = 0 to (2**nStatements) - 1

    # 1. Postulate answer: Extract bits into T array
    for stmt = 1 to 12
        if (tryVal & (2**(stmt-1))) != 0
            T[stmt] = 1
        else
            T[stmt] = 0
        ok
    next

    # 2. Test consistency (Ring: True = 1, False = 0)
    Pass[1]  = (T[1]  = (nStatements = 12))
    Pass[2]  = (T[2]  = (sum_range(T, 7, 12) = 3))
    Pass[3]  = (T[3]  = ((T[2]+T[4]+T[6]+T[8]+T[10]+T[12]) = 2))
    Pass[4]  = (T[4]  = ((not T[5]) or (T[6] and T[7])))
    Pass[5]  = (T[5]  = ((not T[2]) and (not T[3]) and (not T[4])))
    Pass[6]  = (T[6]  = ((T[1]+T[3]+T[5]+T[7]+T[9]+T[11]) = 4))
    Pass[7]  = (T[7]  = (T[2] != T[3])) # XOR replacement
    Pass[8]  = (T[8]  = ((not T[7]) or (T[5] and T[6])))
    Pass[9]  = (T[9]  = (sum_range(T, 1, 6) = 3))
    Pass[10] = (T[10] = (T[11] and T[12]))
    Pass[11] = (T[11] = (sum_range(T, 7, 9) = 1))
    Pass[12] = (T[12] = (sum_range(T, 1, 11) = 4))

    # 3. Check if all statements pass
    totalPass = 0
    for p in Pass totalPass += p next

    if totalPass = 12
        see "Solution! True statements: "
        for i = 1 to 12
            if T[i] = 1 see "" + i + " " ok
        next
        see nl
    ok
next

# Helper function to sum elements in a specific range
func sum_range lst, start, stop
    val = 0
    for i = start to stop
        val += lst[i]
    next
    return val
