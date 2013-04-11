def merge_sort(m)
    if m.length <= 1
        return m
    end

    middle = m.length / 2
    left = m[0,middle]
    right = m[middle..-1]

    left = merge_sort(left)
    right = merge_sort(right)
    merge(left, right)
end

def merge(left, right)
    result = []

    until left.empty? || right.empty?
        # change the direction of this comparison to change the direction of the sort
        if left.first <= right.first
            result << left.shift
        else
            result << right.shift
        end
    end

    unless left.empty?
        result += left
    end
    unless right.empty?
        result += right
    end
    result
end
