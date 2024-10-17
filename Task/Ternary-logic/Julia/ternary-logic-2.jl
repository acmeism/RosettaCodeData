# built-in: true, false and missing

using Printf

const tril = (true, missing, false)

@printf("\n%8s | %8s\n", "A", "¬A")
for A in tril
    @printf("%8s | %8s\n", A, !A)
end

@printf("\n%8s | %8s | %8s\n", "A", "B", "A ∧ B")
for (A, B) in Iterators.product(tril, tril)
    @printf("%8s | %8s | %8s\n", A, B, A & B)
end

@printf("\n%8s | %8s | %8s\n", "A", "B", "A ∨ B")
for (A, B) in Iterators.product(tril, tril)
    @printf("%8s | %8s | %8s\n", A, B, A | B)
end

@printf("\n%8s | %8s | %8s\n", "A", "B", "A ≡ B")
for (A, B) in Iterators.product(tril, tril)
    @printf("%8s | %8s | %8s\n", A, B, A == B)
end

⊃(A, B) = B | !A

@printf("\n%8s | %8s | %8s\n", "A", "B", "A ⊃ B")
for (A, B) in Iterators.product(tril, tril)
    @printf("%8s | %8s | %8s\n", A, B, A ⊃ B)
end
