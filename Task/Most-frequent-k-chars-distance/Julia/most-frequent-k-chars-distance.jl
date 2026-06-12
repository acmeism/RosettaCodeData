using DataStructures

function k_hash(input::AbstractString, K)
    v = [c => count(==(c), input) for c in unique!(collect(input))]
    return OrderedDict(sort!(v, by = p -> p[2], rev = true)[begin:min(K, length(v))])
end

sim_dicts(d1, d2) = sum([cnt + d2[c] for (c, cnt) in d1 if haskey(d2, c)], init = 0)

k_dist(s1, s2, K, max_dist) = max_dist - sim_dicts(k_hash(s1, K), k_hash(s2, K))

const TEST_PAIRS = [
    ("night", "nacht"), ("my", "a"), ("research", "research"),
    ("significant", "capabilities"),
    ("LCLYTHIGRNIYYGSYLYSETWNTGIMLLLITMATAFMGYVLPWGQMSFWGATVITNLFSAIPYIGTNLV",
     "EWIWGGFSVDKATLNRFFAFHFILPFTMVALAGVHLTFLHETGSNNPLGLTSDSDKIPFHPYYTIKDFLG"),
]
function k_distance_test(str1, str2)
    K, max_dist = 2, length(str1) < 20 ? 10 : 100
    dict1, dict2 = k_hash(str1, 2), k_hash(str2, 2)
    println(dict1, ":\n", prod("$c $cnt " for (c, cnt) in dict1))
    println(dict2, ":\n", prod("$c$cnt" for (c, cnt) in dict2))
    println(k_dist(str1, str2, K, max_dist), "\n")
end

foreach(p -> k_distance_test(p[1], p[2]), TEST_PAIRS)
