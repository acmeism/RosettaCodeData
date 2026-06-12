distance(a, b) = sqrt(sum((a .- b) .^ 2))
const _citydist = collect(distance((ci % 10, ci ÷ 10), (cj % 10, cj ÷ 10)) for ci in 1:100, cj in 1:100)

TravelingSalesman.findpath(_citydist, 1_000_000, 1)
