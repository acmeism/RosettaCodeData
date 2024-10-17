include("module.jl")

let rulesets = @.("data/markovrules0" * string(1:5) * ".txt"),
    ruletest = @.("data/markovtest0" * string(1:5) * ".txt")
    for i in eachindex(rulesets, ruletest)
        rules = MarkovAlgos.ruleset(rulesets[i])
        println("# Example n.$i")
        println("Original:\n", readstring(ruletest[i]))
        println("Transformed:\n", MarkovAlgos.apply(ruletest[i], rules))
    end
end
