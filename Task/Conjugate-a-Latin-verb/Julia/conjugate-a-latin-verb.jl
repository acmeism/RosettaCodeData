const conjugators = ["ō", "ās", "at", "āmus", "ātis", "ant"]
conjugate(w, gregex = r"[aā]re$") = (r = replace(w, gregex => ""); [r * s for s in conjugators])

function testregularconjugation(verbvector)
    for verb in verbvector
        println("\nPresent active indicative conjugation of $verb:")
        for result in conjugate(verb)
            println(result)
        end
    end
end

testregularconjugation(["amāre", "dare"])
