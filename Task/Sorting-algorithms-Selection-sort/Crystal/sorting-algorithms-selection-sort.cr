def selectionSort(array : Array)
    (0...array.size-1).each do |i|
        nextMinIndex = i
        (i+1...array.size).each do |j|
            if array[j] < array[nextMinIndex]
                nextMinIndex = j
            end
        end
        if i != nextMinIndex
            array.swap(i, nextMinIndex)
        end
    end
end
