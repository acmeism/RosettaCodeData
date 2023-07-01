module CocktailShakerSorts

using Base.Order, Base.Sort
import Base.Sort: sort!
export CocktailShakerSort

struct CocktailSortAlg <: Algorithm end
const CocktailShakerSort = CocktailSortAlg()

function sort!(A::AbstractVector, lo::Int, hi::Int, a::CocktailSortAlg, ord::Ordering)
    if lo > 1 || hi < length(A)
        return sort!(view(A, lo:hi), 1, length(A), a, ord)
    end
    forward, beginindex, endindex = ord isa ForwardOrdering, 1, length(A) - 1

    while beginindex <= endindex
		newbegin, newend = endindex, beginindex
        for idx in beginindex:endindex
            if (forward && A[idx] > A[idx + 1]) || (!forward && A[idx] < A[idx + 1])
                A[idx + 1], A[idx] = A[idx], A[idx + 1]
                newend = idx
            end
        end
        # end has another in correct place, so narrow end by 1
        endindex = newend - 1

        for idx in endindex:-1:beginindex
            if (forward && A[idx] > A[idx + 1]) || (!forward && A[idx] < A[idx + 1])
                A[idx + 1], A[idx] = A[idx], A[idx + 1]
                newbegin = idx
            end
        end
        # beginning has another in correct place, so narrow beginning by 1
        beginindex = newbegin + 1
    end
    A
end

end # module

using .CocktailShakerSorts
using BenchmarkTools

cocktailshakersort!(v) = sort!(v; alg=CocktailShakerSort)

arr = [5, 8, 2, 0, 6, 1, 9, 3, 4]
println(arr, " => ", sort(arr, alg=CocktailShakerSort), " => ",
    sort(arr, alg=CocktailShakerSort, rev=true))

println("\nUsing default sort, which is Quicksort with integers:")
@btime sort!([5, 8, 2, 0, 6, 1, 9, 3, 4])
println("\nUsing CocktailShakerSort:")
@btime cocktailshakersort!([5, 8, 2, 0, 6, 1, 9, 3, 4])
