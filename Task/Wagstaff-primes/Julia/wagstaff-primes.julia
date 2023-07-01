using Primes

function wagstaffpair(p::Integer)
    isodd(p) || return (false, nothing)
    isprime(p) || return (false, nothing)

    m = (2^big(p) + 1) ÷ 3

    isprime(m) || return (false, nothing)

    return (true, m)
end

function findn_wagstaff_pairs(n_to_find::T) where T <: Integer
    pairs = Tuple{T, BigInt}[]
    count = 0
    i = 2
    while count < n_to_find
        iswag, m = wagstaffpair(i)
        iswag && push!(pairs, (i, m))
        count += iswag
        i += 1
    end
    return pairs
end

function println_wagstaff(pair; max_digit_display::Integer=20)
    p, m = pair
    mstr = string(m)

    if length(mstr) > max_digit_display
        umiddle = cld(max_digit_display, 2)
        lmiddle = fld(max_digit_display, 2)
        mstr = join((mstr[1:umiddle], "...", mstr[end-lmiddle+1:end],
                    " ($(length(mstr)) digits)"))
    end

    println("p = $p, m = $mstr")
end

foreach(println_wagstaff, findn_wagstaff_pairs(24))
