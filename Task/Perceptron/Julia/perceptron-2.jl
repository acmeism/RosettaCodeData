# file _.jl

const SP = include("module.jl")

p = SP.Perceptron(2, 0.1)

a, b = 0.5, 1
X = rand(1000, 2)
y = map(x -> x[2] > a + b * x[1] ? 1 : -1, eachrow(X))

# Accuracy
@show SP.accuracy(p, X, y)

# Train
SP.train!(p, X, y, epochs = 1000)

ahat, bhat = p.weights[1] / p.weights[2], -p.weights[3] / p.weights[2]

using Plots

scatter(X[:, 1], X[:, 2], markercolor = map(x -> x == 1 ? :red : :blue, y))
Plots.abline!(b, a, label = "real line", linecolor = :red, linewidth = 2)

SP.train!(p, X, y, epochs = 1000)
ahat, bhat = p.weights[1] / p.weights[2], -p.weights[3] / p.weights[2]
Plots.abline!(bhat, ahat, label = "predicted line")
