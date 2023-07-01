def in_order(l)
    (0..l.length-2).all? {|i| l[i] <= l[i+1] }
end

def bogosort(l)
   l.shuffle! until in_order(l)
   l
end
