keys = ('a'..'z').to_a	# => a, b, c ... z
vals = (1..26).to_a	# => 1, 2, 3 ... 26

hash = Hash.zip(keys, vals)
p hash
