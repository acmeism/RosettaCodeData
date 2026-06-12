function sigma_sum(n::Int)
    sum_divisors = 0

    for i in 1:isqrt(n)
        if n % i == 0
            sum_divisors += i
            if i != n ÷ i
                sum_divisors += n ÷ i
            end
        end
    end

    return sum_divisors
end

function format_with_commas(n::Int)
    return replace(string(n), r"(?<=[0-9])(?=(?:[0-9]{3})+(?![0-9]))" => ",")
end

function main()
    cnt = 0
    num = 0

    while cnt < 50
        sigma_of_num = sigma_sum(num)
        sigma_of_next_num = sigma_sum(num + 1)

        if sigma_of_num == sigma_of_next_num
            cnt += 1
            formatted_num = format_with_commas(num)
            println("$cnt: $formatted_num")
        end

        num += 1
    end
end

main()
