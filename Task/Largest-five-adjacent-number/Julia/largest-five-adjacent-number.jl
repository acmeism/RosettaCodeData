dig = rand(0:9, 1000)
@show maximum(evalpoly(10, dig[i:i+4]) for i in 1:length(dig)-4)
