def shuffle(l)
    l.sort_by { rand }
end

def bogosort(l)
   l = shuffle(l) until l == l.sort
   l
end
