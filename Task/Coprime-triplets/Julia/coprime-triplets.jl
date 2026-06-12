function coprime_triplets(less_than = 50)
    cpt = [1, 2]
    while true
        m = 1
        while m in cpt || gcd(m, cpt[end]) != 1 || gcd(m, cpt[end - 1]) != 1
            m += 1
        end
        m >= less_than && return cpt
        push!(cpt, m)
    end
end

trps = coprime_triplets()
println("Found $(length(trps)) coprime triplets less than 50:")
foreach(p -> print(rpad(p[2], 3), p[1] %10 == 0 ? "\n" : ""), enumerate(trps))
