function makeInterval(s,e,p)
    return {start=s, end_=e, print_=p}
end

function main()
    local intervals = {
        makeInterval(   2,       1000, true),
        makeInterval(1000,       4000, true),
        makeInterval(   2,      10000, false),
        makeInterval(   2,    1000000, false),
        makeInterval(   2,   10000000, false),
        makeInterval(   2,  100000000, false),
        makeInterval(   2, 1000000000, false)
    }
    for _,intv in pairs(intervals) do
        if intv.start == 2 then
            print("eban numbers up to and including " .. intv.end_ .. ":")
        else
            print("eban numbers between " .. intv.start .. " and " .. intv.end_ .. " (inclusive)")
        end

        local count = 0
        for i=intv.start,intv.end_,2 do
            local b = math.floor(i / 1000000000)
            local r = i % 1000000000
            local m = math.floor(r / 1000000)
            r = i % 1000000
            local t = math.floor(r / 1000)
            r = r % 1000
            if m >= 30 and m <= 66 then m = m % 10 end
            if t >= 30 and t <= 66 then t = t % 10 end
            if r >= 30 and r <= 66 then r = r % 10 end
            if b == 0 or b == 2 or b == 4 or b == 6 then
                if m == 0 or m == 2 or m == 4 or m == 6 then
                    if t == 0 or t == 2 or t == 4 or t == 6 then
                        if r == 0 or r == 2 or r == 4 or r == 6 then
                            if intv.print_ then io.write(i .. " ") end
                            count = count + 1
                        end
                    end
                end
            end
        end

        if intv.print_ then
            print()
        end
        print("count = " .. count)
        print()
    end
end

main()
