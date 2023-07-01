function hashjoin(A::Array, ja::Int, B::Array, jb::Int)
    M = Dict(t[jb] => filter(l -> l[jb] == t[jb], B) for t in B)
    return collect([a, b] for a in A for b in get(M, a[ja], ()))
end

table1 = [(27, "Jonah"),
          (18, "Alan"),
          (28, "Glory"),
          (18, "Popeye"),
          (28, "Alan")]
table2 = [("Jonah", "Whales"),
          ("Jonah", "Spiders"),
          ("Alan", "Ghosts"),
          ("Alan", "Zombies"),
          ("Glory", "Buffy")]

for r in hashjoin(table1, 2, table2, 1)
    println(r)
end
