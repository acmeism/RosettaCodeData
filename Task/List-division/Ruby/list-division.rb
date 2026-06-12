def divide(a, n)
    raise "n must be a positive integer" unless n.is_a?(Integer) && n.positive?
    raise "n is too large" if a.size < n

    q, r = a.size.divmod(n)
    stop = 0

    Enumerator.new do |y|
        (1..n).each do |i|
            start = stop
            stop += i <= r ? q + 1 : q
            y << a[start...stop]
        end
    end
end

begin
    pp divide([94, 94, 13, 77, 35, 10, 51, 27, 60], 6).to_a
    pp divide([19, 46, 43, 17, 94], 1).to_a
    pp divide([93, 88, 40, 88, 30, 68, 84, 25], 3).to_a
    pp divide([88, 94, 10, 27, 54, 14], 3).to_a
    pp divide([31, 19, 63, 57, 57, 74, 50, 14, 38], 4).to_a
    pp divide([72, 57, 89, 55, 36, 84, 10, 95, 99, 35], 7).to_a
    pp divide([23, 49, 57], 10).to_a
rescue Exception => e
    puts e.message
end
