function movingaverage(::Type{T} = Float64; lim::Integer = -1) where T<:Real
	buffer = Vector{T}(0)
	if lim == -1
		# unlimited buffer
		return (y::T) -> begin
			push!(buffer, y)
			return mean(buffer)
		end
	else
		# limited size buffer
		return (y) -> begin
			push!(buffer, y)
			if length(buffer) > lim shift!(buffer) end
			return mean(buffer)
		end
	end
end

test = movingaverage()
@show test(1.0) # mean([1])
@show test(2.0) # mean([1, 2])
@show test(3.0) # mean([1, 2, 3])
