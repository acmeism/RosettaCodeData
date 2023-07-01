const Prime = UInt64
const BasePrime = UInt32
const BasePrimesArray = Array{BasePrime,1}
const SieveBuffer = Array{UInt8,1}

# contains a lazy list of a secondary base primes arrays feed
# NOT thread safe; needs a Mutex gate to make it so...
abstract type BPAS end # stands in for BasePrimesArrays, not defined yet
mutable struct BasePrimesArrays <: BPAS
    thunk :: Union{Nothing,Function} # problem with efficiency - untyped function!!!!!!!!!
    value :: Union{Nothing,Tuple{BasePrimesArray, BPAS}}
    BasePrimesArrays(thunk::Function) = new(thunk)
end
Base.eltype(::Type{BasePrimesArrays}) = BasePrime
Base.IteratorSize(::Type{BasePrimesArrays}) = Base.SizeUnknown() # "infinite"...
function Base.iterate(BPAs::BasePrimesArrays, state::BasePrimesArrays = BPAs)
    if state.thunk !== nothing
        newvalue :: Union{Nothing,Tuple{BasePrimesArray, BasePrimesArrays}} =
            state.thunk() :: Union{Nothing,Tuple{BasePrimesArray
                                                 , BasePrimesArrays}}
        state.value = newvalue
        state.thunk = nothing
        return newvalue
    end
    state.value
end

# count the number of zero bits (primes) in a byte array,
# also works for part arrays/slices, best used as an `@view`...
function countComposites(cmpsts::AbstractArray{UInt8,1})
    foldl((a, b) -> a + count_zeros(b), cmpsts; init = 0)
end

# converts an entire sieved array of bytes into an array of UInt32 primes,
# to be used as a source of base primes...
function composites2BasePrimesArray(low::Prime, cmpsts::SieveBuffer)
    limiti = length(cmpsts) * 8
    len :: Int = countComposites(cmpsts)
    rslt :: BasePrimesArray = BasePrimesArray(undef, len)
    i :: Int = 0
    j :: Int = 1
    @inbounds(
    while i < limiti
        if cmpsts[i >>> 3 + 1] & (1 << (i & 7)) == 0
            rslt[j] = low + i + i
            j += 1
        end
        i += 1
    end)
    rslt
end

# sieving work done, based on low starting value for the given buffer and
# the given lazy list of base prime arrays...
function sieveComposites(low::Prime, buffer::Array{UInt8,1},
                                     bpas::BasePrimesArrays)
    lowi :: Int = (low - 3) ÷ 2
    len :: Int = length(buffer)
    limiti :: Int = len * 8 - 1
    nexti :: Int = lowi + limiti
    for bpa::BasePrimesArray in bpas
        for bp::BasePrime in bpa
            bpint :: Int = bp
            bpi :: Int = (bpint - 3) >>> 1
            starti :: Int = 2 * bpi * (bpi + 3) + 3
            starti >= nexti && return
            if starti >= lowi starti -= lowi
            else
                r :: Int = (lowi - starti) % bpint
                starti = r == 0 ? 0 : bpint - r
            end
            lmti :: Int = limiti - 40 * bpint
            @inbounds(
            if bpint <= (len >>> 2) starti <= lmti
                for i in 1:8
                    if starti > limiti break end
                    mask = convert(UInt8,1) << (starti & 7)
                    c = starti >>> 3 + 1
                    while c <= len
                        buffer[c] |= mask
                        c += bpint
                    end
                    starti += bpint
                end
            else
                c = starti
                while c <= limiti
                    buffer[c >>> 3 + 1] |= convert(UInt8,1) << (c & 7)
                    c += bpint
                end
            end)
        end
    end
    return
end

# starts the secondary base primes feed with minimum size in bits set to 4K...
# thus, for the first buffer primes up to 8293,
# the seeded primes easily cover it as 97 squared is 9409.
function makeBasePrimesArrays() :: BasePrimesArrays
    cmpsts :: SieveBuffer = Array{UInt8,1}(undef, 512)
    function nextelem(low::Prime, bpas::BasePrimesArrays) ::
                                    Tuple{BasePrimesArray, BasePrimesArrays}
        # calculate size so that the bit span is at least as big as the
        # maximum culling prime required, rounded up to minsizebits blocks...
        reqdsize :: Int = 2 + isqrt(1 + low)
        size :: Int = (reqdsize ÷ 4096 + 1) * 4096 ÷ 8 # size in bytes
        if size > length(cmpsts) cmpsts = Array{UInt8,1}(undef, size) end
        fill!(cmpsts, 0)
        sieveComposites(low, cmpsts, bpas)
        arr :: BasePrimesArray = composites2BasePrimesArray(low, cmpsts)
        next :: Prime = low + length(cmpsts) * 8 * 2
        arr, BasePrimesArrays(() -> nextelem(next, bpas))
    end
    # pre-seeding breaks recursive race,
    # as only known base primes used for first page...
    preseedarr :: BasePrimesArray = # pre-seed to 100, can sieve to 10,000...
        [ 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41
        , 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
        ]
    nextfunc :: Function = () ->
        (nextelem(convert(Prime,101), makeBasePrimesArrays()))
    firstfunc :: Function = () -> (preseedarr, BasePrimesArrays(nextfunc))
    BasePrimesArrays(firstfunc)
end

# an iterator over successive sieved buffer composite arrays,
# returning a tuple of the value represented by the lowest possible prime
# in the sieved composites array and the array itself;
# the array has a 16 Kilobytes minimum size (CPU L1 cache), but
# will grow so that the bit span is larger than the
# maximum culling base prime required, possibly making it larger than
# the L1 cache for large ranges, but still reasonably efficient using
# the L2 cache: very efficient up to about 16e9 range;
# reasonably efficient to about 2.56e14 for two Megabyte L2 cache = > 1 week...
struct PrimesPages
    baseprimes :: BasePrimesArrays
    PrimesPages() = new(makeBasePrimesArrays())
end
Base.eltype(::Type{PrimesPages}) = SieveBuffer
Base.IteratorSize(::Type{PrimesPages}) = Base.SizeUnknown() # "infinite"...
function Base.iterate(PP::PrimesPages,
                      state :: Tuple{Prime,SieveBuffer} =
                            ( convert(Prime,3), Array{UInt8,1}(undef,16384) ))
    (low, cmpsts) = state
    # calculate size so that the bit span is at least as big as the
    # maximum culling prime required, rounded up to minsizebits blocks...
    reqdsize :: Int = 2 + isqrt(1 + low)
    size :: Int = (reqdsize ÷ 131072 + 1) * 131072 ÷ 8 # size in bytes
    if size > length(cmpsts) cmpsts = Array{UInt8,1}(undef, size) end
    fill!(cmpsts, 0)
    sieveComposites(low, cmpsts, PP.baseprimes)
    newlow :: Prime = low + length(cmpsts) * 8 * 2
    ( low, cmpsts ), ( newlow, cmpsts )
end

function countPrimesTo(range::Prime) :: Int64
    range < 3 && ((range < 2 && return 0) || return 1)
    count :: Int64 = 1
    for ( low, cmpsts ) in PrimesPages() # almost never exits!!!
        if low + length(cmpsts) * 8 * 2 > range
            lasti :: Int = (range - low) ÷ 2
            count += countComposites(@view cmpsts[1:lasti >>> 3])
            count += count_zeros(cmpsts[lasti >>> 3 + 1] |
                                 (0xFE << (lasti & 7)))
            return count
        end
        count += countComposites(cmpsts)
    end
    count
end

# iterator over primes from above page iterator;
# unless doing something special with individual primes, usually unnecessary;
# better to do manipulations based on the composites bit arrays...
# takes at least as long to enumerate the primes as sieve them...
mutable struct PrimesPaged
    primespages :: PrimesPages
    primespageiter :: Tuple{Tuple{Prime,SieveBuffer},Tuple{Prime,SieveBuffer}}
    PrimesPaged() = let PP = PrimesPages(); new(PP, Base.iterate(PP)) end
end
Base.eltype(::Type{PrimesPaged}) = Prime
Base.IteratorSize(::Type{PrimesPaged}) = Base.SizeUnknown() # "infinite"...
function Base.iterate(PP::PrimesPaged, state::Int = -1 )
    state < 0 && return Prime(2), 0
    (low, cmpsts) = PP.primespageiter[1]
    len = length(cmpsts) * 8
    @inbounds(
    while state < len && cmpsts[state >>> 3 + 1] &
                         (UInt8(1) << (state & 7)) != 0
        state += 1
    end)
    if state >= len
        PP.primespageiter = Base.iterate(PP.primespages, PP.primespageiter[2])
        return Base.iterate(PP, 0)
    end
    low + state + state, state + 1
end
