J(A, B) = begin i, u = length(A ∩ B), length(A ∪ B); u == 0 ? 1//1 : i // u end

A = Int[]
B = [1, 2, 3, 4, 5]
C = [1, 3, 5, 7, 9]
D = [2, 4, 6, 8, 10]
E = [2, 3, 5, 7]
F = [8]
testsets = [A, B, C, D, E, F]

println("Set A             Set B             J(A, B)\n", "-"^44)
for a in testsets, b in testsets
    println(rpad(isempty(a) ? "[]" : a, 18), rpad(isempty(b) ? "[]" : b, 18),
        replace(string(J(a, b)), "//" => "/"))
end
