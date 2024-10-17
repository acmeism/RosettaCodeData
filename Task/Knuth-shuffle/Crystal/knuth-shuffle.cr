def knuthShuffle(items : Array)
    i = items.size-1
    while i > 1
        j = Random.rand(0..i)
        items.swap(i, j)

        i -= 1
    end
end
