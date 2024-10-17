function egyptian_divrem(dividend, divisor)
    answer = accumulator = 0
    row(powers_of_2, doublings) =
        if dividend > doublings
            row(2 * powers_of_2, 2 * doublings)
            if accumulator + doublings ≤ dividend
                answer += powers_of_2
                accumulator += doublings
            end
        end
    row(1, divisor)
    answer, dividend - accumulator
end

egyptian_divrem(580, 34)
