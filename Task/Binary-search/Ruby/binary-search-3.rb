haystack = [0,1,4,5,6,7,8,9,12,26,45,67,78,90,98,123,211,234,456,769,865,2345,3215,14345,24324]
needles = [0,42,45,24324,99999]

needles.select{|needle| haystack.bsearch{|hay| needle <=> hay} } # => [0, 45, 24324]
