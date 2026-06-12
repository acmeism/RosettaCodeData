module TravelingSalesman

using Random, Printf

# Eₛ: length(path)
Eₛ(distances, path) = sum(distances[ci, cj] for (ci, cj) in zip(path, Iterators.drop(path, 1)))
# T: temperature
T(k, kmax, kT) = kT * (1 - k / kmax)
# Alternative temperature:
#T(k, kmax, kT) = kT * (1 - sin(π / 2 * k / kmax))

# ΔE = Eₛ_new - Eₛ_old > 0
# Prob. to move if ΔE > 0, → 0 when T → 0 (fronzen state)
P(ΔE, k, kmax, kT) = exp(-ΔE / T(k, kmax, kT))

# ∆E from path ( .. a u b .. c v d ..) to (.. a v b ... c u d ..)
# ∆E before swapping (u,v)
# Quicker than Eₛ(s_next) - Eₛ(path)
function dE(distances, path, u, v)
    a = distances[path[u - 1], path[u]]
    b = distances[path[u + 1], path[u]]
    c = distances[path[v - 1], path[v]]
    d = distances[path[v + 1], path[v]]

    na = distances[path[u - 1], path[v]]
    nb = distances[path[u + 1], path[v]]
    nc = distances[path[v - 1], path[u]]
    nd = distances[path[v + 1], path[u]]

    if v == u + 1
        return (na + nd) - (a + d)
    elseif u == v + 1
        return (nc + nb) - (c + b)
    else
        return (na + nb + nc + nd) - (a + b + c + d)
    end
end

const dirs = [1, -1, 10, -10, 9, 11, -11, -9]

function _prettypath(path)
    r = IOBuffer()
    for g in Iterators.partition(path, 10)
        println(r, join(lpad.(g, 3), ", "))
    end
    return String(take!(r))
end

function findpath(distances, kmax, kT)
    n = size(distances, 1)
    path = vcat(1, shuffle(2:n), 1)
    Emin = Eₛ(distances, path)
    @printf("\n# Entropy(s₀) = %10.2f\n", Emin)
    println("# Random path: \n", _prettypath(path))

    for k in Base.OneTo(kmax)
        if iszero(k % (kmax ÷ 10))
            @printf("k: %10d | T: %8.4f | Eₛ: %8.4f\n", k, T(k, kmax, kT), Eₛ(distances, path))
        end
        u = rand(2:n)
        v = path[u] + rand(dirs)
        v ∈ 2:n || continue

        δE = dE(distances, path, u, v)
        if δE < 0 || P(δE, k, kmax, kT) ≥ rand()
            path[u], path[v] = path[v], path[u]
            Emin += δE
        end
    end

    @printf("k: %10d | T: %8.4f | Eₛ: %8.4f\n", kmax, T(kmax, kmax, kT), Eₛ(distances, path))
    println("\n# Found path:\n", _prettypath(path))
    return path
end

end  # module TravelingSalesman
