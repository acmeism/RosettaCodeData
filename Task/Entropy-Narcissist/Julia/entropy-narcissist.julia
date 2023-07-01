using DataStructures

entropy(s) = -sum(x -> x / length(s) * log2(x / length(s)), values(counter(s)))
println("self-entropy: ", entropy(read(Base.source_path(), String)))
