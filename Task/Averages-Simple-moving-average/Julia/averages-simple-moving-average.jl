using Statistics

"""
    Return a function that computes a moving average over a buffer of values.

    Optional Named Arguments:
    - ` buffer = buffer::Vector{T}`: optional initial buffer of values of
            type `T` (default empty Float64 array)
    - `limit = limit::Integer`: optional maximum length of the buffer;
       if -1 (default), the buffer is unlimited

    Returns:
    - a function `(y::T) -> mean(buffer)` that, when called with a new value `y`,
        appends it to the buffer (and removes the oldest value if the buffer exceeds
        `limit`), and returns the mean of the buffer
"""
function movingaverage(; buffer::Vector{T} = Float64[], limit::Integer = -1) where T <: Real
    return (y::T) -> begin
        push!(buffer, T(y))
        limit > 0 && length(buffer) > limit && popfirst!(buffer)
        return mean(buffer)
    end
end


test = movingaverage()
@show test(1.0) # mean([1])
@show test(2.0) # mean([1, 2])
@show test(3.0) # mean([1, 2, 3])
