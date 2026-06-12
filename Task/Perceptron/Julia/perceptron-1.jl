# file module.jl

module SimplePerceptrons

# default activation function
step(x) = x > 0 ? 1 : -1

mutable struct Perceptron{T, F}
    weights::Vector{T}
    lr::T
    activate::F
end

Perceptron{T}(n::Integer, lr = 0.01, f::Function = step) where T =
    Perceptron{T, typeof(f)}(2 .* rand(n + 1) .- 1, lr, f)
Perceptron(args...) = Perceptron{Float64}(args...)

@views predict(p::Perceptron, x::AbstractVector) = p.activate(p.weights[1] + x' * p.weights[2:end])
@views predict(p::Perceptron, X::AbstractMatrix) = p.activate.(p.weights[1] .+ X * p.weights[2:end])

function train!(p::Perceptron, X::AbstractMatrix, y::AbstractVector; epochs::Integer = 100)
    for _ in Base.OneTo(epochs)
        yhat = predict(p, X)
        err = y .- yhat
        ΔX = p.lr .* err .* X
        for ind in axes(ΔX, 1)
            p.weights[1] += err[ind]
            p.weights[2:end] .+= ΔX[ind, :]
        end
    end
    return p
end

accuracy(p, X::AbstractMatrix, y::AbstractVector) = count(y .== predict(p, X)) / length(y)

end  # module SimplePerceptrons
