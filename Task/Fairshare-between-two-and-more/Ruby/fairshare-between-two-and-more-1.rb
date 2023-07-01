def turn(base, n)
    sum = 0
    while n != 0 do
        rem = n % base
        n = n / base
        sum = sum + rem
    end
    return sum % base
end

def fairshare(base, count)
    print "Base %2d: " % [base]
    for i in 0 .. count - 1 do
        t = turn(base, i)
        print " %2d" % [t]
    end
    print "\n"
end

def turnCount(base, count)
    cnt = Array.new(base, 0)

    for i in 0 .. count - 1 do
        t = turn(base, i)
        cnt[t] = cnt[t] + 1
    end

    minTurn = base * count
    maxTurn = -1
    portion = 0
    for i in 0 .. base - 1 do
        if cnt[i] > 0 then
            portion = portion + 1
        end
        if cnt[i] < minTurn then
            minTurn = cnt[i]
        end
        if cnt[i] > maxTurn then
            maxTurn = cnt[i]
        end
    end

    print "  With %d people: " % [base]
    if 0 == minTurn then
        print "Only %d have a turn\n" % portion
    elsif minTurn == maxTurn then
        print "%d\n" % [minTurn]
    else
        print "%d or %d\n" % [minTurn, maxTurn]
    end
end

def main
    fairshare(2, 25)
    fairshare(3, 25)
    fairshare(5, 25)
    fairshare(11, 25)

    puts "How many times does each get a turn in 50000 iterations?"
    turnCount(191, 50000)
    turnCount(1377, 50000)
    turnCount(49999, 50000)
    turnCount(50000, 50000)
    turnCount(50001, 50000)
end

main()
