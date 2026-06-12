function qsort(array)
    length(array) < 2 && return array
    mid, left, right  = first(array), eltype(array)[], eltype(array)[]
    for elem in @view array[begin+1:end]
        push!(lowercase(elem) < lowercase(mid) ? left : right, elem)
    end
    return vcat(qsort(left), mid, qsort(right))
end

qsort(str::String) = str |> collect |> qsort |> String

function testqsort(s::String, stripws= true)
    println("Unsorted -> ", s)
    println("Sorted   -> ", stripws ? strip(qsort(s)) : qsort(s))
end

testqsort("forever julia programming language")
testqsort("Now is the time for all good men to come to the aid of their country.")
