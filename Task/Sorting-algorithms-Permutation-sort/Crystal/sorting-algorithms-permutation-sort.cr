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

def permutation_sort(items : Array)
    items.each_permutation do |permutation|
        if sorted?(permutation)
            return permutation
        end
    end
end
