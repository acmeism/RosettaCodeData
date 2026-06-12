# Sample price generation
const price_list_size = rand(99000:100999)
const price_list = rand(0:99999, price_list_size)
const delta_price = 1   # Minimum difference between any two different prices.

""" The API provides these two """
get_prange_count(startp, endp) = sum([startp <= r <= endp for r in price_list])
get_max_price() = maximum(price_list)

""" Binary search for num items between mn and mx, adjusting mx """
function get_5k(mn=0, mx=get_max_price(), num=5_000)
    count = get_prange_count(mn, mx)
    delta_mx = (mx - mn) / 2
    while count != num && delta_mx >= delta_price / 2
        mx += (count > num ? -delta_mx : +delta_mx)
        mx = floor(mx)
        count, delta_mx = get_prange_count(mn, mx), delta_mx / 2
    end
    return mx, count
end

""" Get all non-overlapping ranges """
function get_all_5k(mn=0, mx=get_max_price(), num=5_000)
    partmax, partcount = get_5k(mn, mx, num)
    result = [(mn, partmax, partcount)]
    while partmax < mx
        partmin = partmax + delta_price
        partmax, partcount = get_5k(partmin, mx, num)
        @assert(partcount > 0, "pricelist from $partmin has too many same price")
        push!(result, (partmin, partmax, partcount))
    end
    return result
end

function testpricelist()
    println("Using $price_list_size random prices from 0 to $(get_max_price()).")
    result = get_all_5k()
    println("Splits into $(length(result)) bins of approximately 5000 elements.")
    for (mn, mx, count) in result
        println("  From $(Float32(mn)) ... $(Float32(mx)) with $count items.")
    end
    if length(price_list) != sum([x[3] for x in result])
        print("\nWhoops! Some items missing.")
    end
end

testpricelist()
