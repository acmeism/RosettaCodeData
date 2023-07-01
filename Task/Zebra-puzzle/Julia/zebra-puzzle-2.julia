# Julia 1.4
using JuMP
using GLPK

c = Dict(s => i for (i, s) in enumerate(split("blue green ivory red yellow")))
n = Dict(s => i for (i, s) in enumerate(split("english japanese norwegian spanish ukrainian")))
p = Dict(s => i for (i, s) in enumerate(split("dog fox horse snails zebra")))
d = Dict(s => i for (i, s) in enumerate(split("coffee milk orangejuice tea water")))
s = Dict(s => i for (i, s) in enumerate(split("chesterfields kools luckystrikes parliaments winstons")))

model = Model(GLPK.Optimizer)

@variable(model, colors[1:5, 1:5], Bin)
@constraints(model, begin
    [h in 1:5], sum(colors[h, :]) == 1
    [c in 1:5], sum(colors[:, c]) == 1
end)

@variable(model, nations[1:5, 1:5], Bin)
@constraints(model, begin
    [h in 1:5], sum(nations[h, :]) == 1
    [n in 1:5], sum(nations[:, n]) == 1
end)

@variable(model, pets[1:5, 1:5], Bin)
@constraints(model, begin
    [h in 1:5], sum(pets[h, :]) == 1
    [p in 1:5], sum(pets[:, p]) == 1
end)

@variable(model, drinks[1:5, 1:5], Bin)
@constraints(model, begin
    [h in 1:5], sum(drinks[h, :]) == 1
    [d in 1:5], sum(drinks[:, d]) == 1
end)

@variable(model, smokes[1:5, 1:5], Bin)
@constraints(model, begin
    [h in 1:5], sum(smokes[h, :]) == 1
    [s in 1:5], sum(smokes[:, s]) == 1
end)

@constraint(model, [h=1:5], colors[h, c["red"]] == nations[h, n["english"]])
@constraint(model, [h=1:5], nations[h, n["spanish"]] == pets[h, p["dog"]])
@constraint(model, [h=1:5], colors[h, c["green"]] == drinks[h, d["coffee"]])
@constraint(model, [h=1:5], nations[h, n["ukrainian"]] == drinks[h, d["tea"]])
@constraint(model, [h=1:5], colors[h, c["ivory"]] == get(colors, (h+1, c["green"]), 0))
@constraint(model, [h=1:5], pets[h, p["snails"]] == smokes[h, s["winstons"]])
@constraint(model, [h=1:5], colors[h, c["yellow"]] == smokes[h, s["kools"]])
@constraint(model, drinks[3, d["milk"]] == 1)
@constraint(model, nations[1, n["norwegian"]] == 1)
@constraint(model, [h=1:5], (1-pets[h, p["fox"]]) + get(smokes,(h-1, s["chesterfields"]), 0) + get(smokes, (h+1, s["chesterfields"]), 0) >= 1)
@constraint(model, [h=1:5], (1-pets[h, p["horse"]]) + get(smokes,(h-1, s["kools"]), 0) + get(smokes, (h+1, s["kools"]), 0) >= 1)
@constraint(model, [h=1:5], drinks[h, d["orangejuice"]] == smokes[h, s["luckystrikes"]])
@constraint(model, [h=1:5], nations[h, n["japanese"]] == smokes[h, s["parliaments"]])
@constraint(model, [h=1:5], (1-nations[h, n["norwegian"]]) + get(colors, (h-1, c["blue"]), 0) + get(colors, (h+1, c["blue"]), 0) >= 1)

optimize!(model)

if termination_status(model) == MOI.OPTIMAL && primal_status(model) == MOI.FEASIBLE_POINT
    m = map(1:5) do h
        [Dict(values(c) .=> keys(c))[findfirst(value.(colors)[h, :] .≈ 1.0)],
         Dict(values(n) .=> keys(n))[findfirst(value.(nations)[h, :] .≈ 1.0)],
         Dict(values(p) .=> keys(p))[findfirst(value.(pets)[h, :] .≈ 1.0)],
         Dict(values(d) .=> keys(d))[findfirst(value.(drinks)[h, :] .≈ 1.0)],
         Dict(values(s) .=> keys(s))[findfirst(value.(smokes)[h, :] .≈ 1.0)]]
    end
end

using DataFrames
DataFrame(colors=getindex.(m, 1),
          nations=getindex.(m, 2),
          pets=getindex.(m, 3),
          drinks=getindex.(m, 4),
          smokes=getindex.(m, 5))
