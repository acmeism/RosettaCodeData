@show findfirst(["no", "?", "yes", "maybe", "yes"], "yes")
@show indexin(["yes"], ["no", "?", "yes", "maybe", "yes"])
@show findin(["no", "?", "yes", "maybe", "yes"], ["yes"])
@show find(["no", "?", "yes", "maybe", "yes"] .== "yes")
