iseq(f, g) = any(n -> f == circshift(g, n), 1:length(g))

function toface(evec)
    try
        ret, edges = collect(evec[1]), copy(evec[2:end])
        while !isempty(edges)
            i = findfirst(x -> ret[end] == x[1] || ret[end] == x[2], edges)
            push!(ret, ret[end] == edges[i][1] ? edges[i][2] : edges[i][1])
            deleteat!(edges, i)
        end
        return ret[1:end-1]
    catch
        println("Invalid edges vector: $evec")
        exit(1)
    end
end

const faces1 = [
    [[8, 1, 3], [1, 3, 8]],
    [[18, 8, 14, 10, 12, 17, 19], [8, 14, 10, 12, 17, 19, 18]]
]

const faces2 = [
    [(1, 11), (7, 11), (1, 7)], [(11, 23), (1, 17), (17, 23), (1, 11)],
    [(8, 14), (17, 19), (10, 12), (10, 14), (12, 17), (8, 18), (18, 19)],
    [(1, 3), (9, 11), (3, 11), (1, 11)]
]

for faces in faces1
    println("Faces are ", iseq(faces[1], faces[2]) ? "" : "not ", "equivalent.")
end

for face in faces2
    println(toface(face))
end
