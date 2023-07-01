def knuthShuffle(items : Array)
    i = items.size-1
    while i > 1
        j = Random.rand(0..i)
        items.swap(i, j)

        i -= 1
    end
end

def sorted?(items : Array)
    prev = items[0]
    items.each do |item|
        if item < prev
            return false
        end
        prev = item
    end
    return true
end

def bogoSort(items : Array)
    while !sorted?(items)
        knuthShuffle(items)
    end
end
