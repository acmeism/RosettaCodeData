def extended_gcd(a, b)
    last_remainder, remainder = a.abs, b.abs
    x, last_x = 0, 1

    until remainder == 0
        tmp = remainder
        quotient, remainder = last_remainder.divmod(remainder)
        last_remainder = tmp
        x, last_x = last_x - quotient * x, x
    end

    return last_remainder, last_x * (a < 0 ? -1 : 1)
end


def invmod(e, et)
    g, x = extended_gcd(e, et)
    unless g == 1
        raise "Multiplicative inverse modulo does not exist"
    end
    return x % et
end


def chinese_remainder(mods, remainders)
    max = mods.product
    series = remainders.zip(mods).map { |r, m| r * max * invmod(max // m, m) // m }
    return series.sum % max
end


puts chinese_remainder([3, 5, 7], [2, 3, 2])
puts chinese_remainder([5, 7, 9, 11], [1, 2, 3, 4])
