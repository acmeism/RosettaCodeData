function perm(A)
  m, n = size(A)
  if m != n; throw(ArgumentError("permanent is for square matrices only")); end
  sum(σ -> prod(i -> A[i,σ[i]], 1:n), permutations(1:n))
end
