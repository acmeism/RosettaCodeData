qsort(L) = isempty(L) ? L : vcat(qsort(filter(x -> x < L[1], L[2:end])), L[1:1], qsort(filter(x -> x >= L[1], L[2:end])))
