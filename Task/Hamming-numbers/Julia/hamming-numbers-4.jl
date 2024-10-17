function nthhamming(n :: UInt64) # :: Tuple{UInt32, UInt32, UInt32}
    # take care of trivial cases too small for band size estimation to work...
    n < 1 && throw("nthhamming:  argument must be greater than zero!!!")
    n < 2 && return (0, 0, 0)
    n < 3 && return (1, 0, 0)

    # some constants...
    log2of2, log2of3, log2of5 = 1.0, log(2, 3), log(2, 5)
    fctr, crctn = 6.0 * log2of3 * log2of5, log(2, sqrt(30))
    log2est = (fctr * Float64(n))^(1.0 / 3.0) - crctn # log2 answer from WP formula
    log2hi = log2est + 1.0 / log2est; width = 2.0 / log2est # up to 2X higher/lower

    # loop to find the count of regular numbers and band of possible candidates...
    count :: UInt64 = 0; band = Vector{Tuple{Float64,Tuple{UInt32,UInt32,UInt32}}}()
    fiveslmt = UInt32(ceil(log2hi / log2of5)); fives :: UInt32 = 0
    while fives < fiveslmt
        log2p = log2hi - fives * log2of5
        threeslmt = UInt32(ceil(log2p / log2of3)); threes :: UInt32 = 0
        while threes < threeslmt
            log2q = log2p - threes * log2of3
            twos = UInt32(floor(log2q)); frac = log2q - twos; count += twos + 1
            frac <= width && push!(band, (log2hi - frac, (twos, threes, fives)))
            threes += 1
        end
        fives += 1
    end

    # process the band found including checks for validity and range...
    n > count && throw("nthhamming:  band high estimate is too low!!!")
    ndx = count - n + 1
    ndx > length(band) && throw("nthhamming:  band width estimate is too narrow!!!")
    sort!(band, by=(tpl -> let (lg,_) = tpl; -lg end)) # sort in decending order

    # get and return the answer...
    _, tri = band[ndx]
    tri
end

foreach(x-> print(trival(nthhamming(UInt(x))), " "), 1:20); println()
println(trival(nthhamming(UInt64(1691))))
println(trival(nthhamming(UInt64(1000000))))
