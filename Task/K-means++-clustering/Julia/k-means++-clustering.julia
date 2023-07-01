# run via Julia REPL
using Clustering, Plots, DataFrames, RDatasets

const iris = dataset("datasets", "iris")
plt1 = plot(title= "Species Classification",  xlabel = "Sepal Width", ylabel = "Sepal length")
plt2 = plot(title= "Kmeans++ Classification",  xlabel = "Sepal Width", ylabel = "Sepal length")

for (i, sp) in enumerate(unique(iris[!, :Species]))
    idx = iris[!, :Species] .== sp
    spwidth, splength = iris[idx, :SepalWidth], iris[idx, :SepalLength]
    scatter!(plt1, spwidth, splength, color = [:red, :green, :blue][i], legend = false)
end

features = collect(Matrix(iris[!, 1:4])')

# K Means ++
result = kmeans(features, 3, init = KmppAlg())  # set to 3 clusters with kmeans++

for center in unique(result.assignments)
    idx = result.assignments .== center
    spwidth, splength = iris[idx, :SepalWidth], iris[idx, :SepalLength]
    scatter!(plt2, spwidth, splength, color = [:green, :red, :blue][center], legend = false)
end

plot(plt1, plt2)
