def shuffle(l)
    l.sort_by { rand }
end

def bogosort(l)
    l = shuffle(l) until in_order(l)
    l
end

def in_order(l)
    (0..l.length-2).all? {|i| l[i] <= l[i+1] }
end
