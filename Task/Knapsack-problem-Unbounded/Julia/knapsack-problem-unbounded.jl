using JuMP
using GLPKMathProgInterface

model = Model(solver=GLPKSolverMIP())

@variable(model, vials_of_panacea >= 0, Int)
@variable(model, ampules_of_ichor >= 0, Int)
@variable(model, bars_of_gold >= 0, Int)

@objective(model, Max, 3000*vials_of_panacea + 1800*ampules_of_ichor + 2500*bars_of_gold)

@constraint(model, 0.3*vials_of_panacea + 0.2*ampules_of_ichor + 2.0*bars_of_gold <= 25.0)
@constraint(model, 0.025*vials_of_panacea + 0.015*ampules_of_ichor + 0.002*bars_of_gold <= 0.25)

println("The optimization problem to be solved is:")
println(model)

status = solve(model)

println("Objective value: ", getobjectivevalue(model))
println("vials of panacea = ", getvalue(vials_of_panacea))
println("ampules of ichor = ", getvalue(ampules_of_ichor))
println("bars of gold = ", getvalue(bars_of_gold))
