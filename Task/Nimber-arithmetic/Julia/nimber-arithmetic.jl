""" highest power of 2 that divides a given number """
hpo2(n) = n & -n

""" base 2 logarithm of the highest power of 2 dividing a given number """
lhpo2(n) = begin q, m = 0, hpo2(n); while iseven(m) m >>= 1; q += 1 end; q end

""" nim-sum of two numbers """
nimsum(x, y) = x ⊻ y

""" nim-product of two numbers """
function nimprod(x, y)
    (x < 2 || y < 2) && return x * y
    h = hpo2(x)
    (x > h) && return nimprod(h, y) ⊻ nimprod(x ⊻ h, y)
    (hpo2(y) < y) && return nimprod(y, x)
    xp, yp = lhpo2(x), lhpo2(y)
    comp = xp & yp
    comp == 0 && return x * y
    h = hpo2(comp)
    return nimprod(nimprod(x >> h, y >> h), 3 << (h - 1))
end

""" print a table of nim-sums or nim-products """
function printtable(n, op)
    println(" $op |", prod([lpad(i, 3) for i in 0:n]), "\n--- -", "---"^(n + 1))
    for j in 0:n
        print(lpad(j, 2), " |")
        for i in 0:n
            print(lpad(op == '⊕' ? nimsum(i, j) : nimprod(i, j), 3))
        end
        print(j == n ? "\n\n" : "\n")
    end
end

const a, b = 21508, 42689

printtable(15, '⊕')
printtable(15, '⊗')
println("nim-sum:     $a ⊕ $b = $(nimsum(a, b))")
println("nim-product: $a ⊗ $b = $(nimprod(a, b))")
