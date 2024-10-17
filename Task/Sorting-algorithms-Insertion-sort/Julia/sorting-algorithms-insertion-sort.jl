# v0.6

function insertionsort!(A::Array{T}) where T <: Number
    for i in 1:length(A)-1
        value = A[i+1]
        j = i
        while j > 0 && A[j] > value
            A[j+1] = A[j]
            j -= 1
        end
        A[j+1] = value
    end
    return A
end

x = randn(5)
@show x insertionsort!(x)
