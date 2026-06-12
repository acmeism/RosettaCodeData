function mergesort!(array, lt = <, low = 1, high = length(array), tmp=similar(array, 0))
    high <= low && return array
    middle = low + div(high - low, 2)
    (length(tmp) < middle - low + 1) && resize!(tmp, middle - low + 1)

    mergesort!(array, lt, low,  middle, tmp)
    mergesort!(array, lt, middle + 1, high, tmp)

    i, j = 1, low
    while j <= middle
        tmp[i] = array[j]
        i += 1
        j += 1
    end

    i, k = 1, low
    while k < j <= high
        if lt(array[j], tmp[i])
            array[k] = array[j]
            j += 1
        else
            array[k] = tmp[i]
            i += 1
        end
        k += 1
    end

    while k < j
        array[k] = tmp[i]
        k += 1
        i += 1
    end
    return array
end

mergesort(str::String) = String(mergesort!(collect(str)))

function testmergesort(s::String, stripws= true)
    println("Unsorted -> ", s)
    println("Sorted   -> ", stripws ? strip(mergesort(s)) : mergesort(s))
end

testmergesort("forever julia programming language")
testmergesort("Now is the time for all good men to come to the aid of their country.", false)
