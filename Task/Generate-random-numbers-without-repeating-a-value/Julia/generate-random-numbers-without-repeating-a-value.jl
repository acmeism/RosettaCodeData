using Random
Random.seed!(1234567)

# 1. built in

@show shuffle(1:20)

# 2. from standard random generator rand()

myshuffle(urn::AbstractVector) =
    map(length(urn):-1:1) do len
        ball = urn[ceil(Int, rand() * len)]
        urn = setdiff(urn, ball)
        ball
    end

@show myshuffle(1:20);
