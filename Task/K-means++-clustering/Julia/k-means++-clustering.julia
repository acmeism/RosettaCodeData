# run via Julia REPL
using Clustering, Makie, DataFrames, RDatasets

const iris = dataset("datasets", "iris")
const colors = [:red, :green, :blue]
const plt = Vector{Any}(undef,2)

scene1 = Scene()
scene2 = Scene()

for (i, sp) in enumerate(unique(iris[:Species]))
    idx = iris[:Species] .== sp
    sel = iris[idx, [:SepalWidth, :SepalLength]]
    plt[1] = scatter!(scene1, sel[1], sel[2], color = colors[i],
        limits = FRect(1.5, 4.0, 3.0, 4.0))
end

features = permutedims(convert(Array, iris[1:4]), [2, 1])

# K Means ++
result = kmeans(features, 3, init = :kmpp)  # set to 3 clusters with kmeans++ :kmpp

for center in unique(result.assignments)
    idx = result.assignments .== center
    sel = iris[idx, [:SepalWidth, :SepalLength]]
    plt[2] = scatter!(scene2, sel[1], sel[2], color = colors[center],
        limits = FRect(1.5, 4.0, 3.0, 4.0))
end

scene2[Axis][:names][:axisnames] = scene1[Axis][:names][:axisnames] =
    ("Sepal Width", "Sepal Length")
t1 = text(Theme(), "Species Classification", camera=campixel!)
t2 = text(Theme(), "Kmeans Classification", camera=campixel!)
vbox(hbox(plt[1], t1), hbox(plt[2], t2))
