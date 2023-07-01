function radixsort(tobesorted::Vector{Int64})
    arr = deepcopy(tobesorted)
    for shift in 63:-1:0
        tmp = Vector{Int64}(undef, length(arr))
        j = 0
        for i in 1:length(arr)
            if (shift == 0) == ((arr[i] << shift) >= 0)
                arr[i - j] = arr[i]
            else
                tmp[j + 1] = arr[i]
                j += 1
            end
        end
        tmp[j+1:end] .= arr[1:length(tmp)-j]
        arr = tmp
    end
    arr
end

function testradixsort()
    arrays = [[170, 45, 75, -90, -802, 24, 2, 66], [-4, 5, -26, 58, -990, 331, 331, 990, -1837, 2028]]
    for array in arrays
        println(radixsort(array))
    end
end

testradixsort()
