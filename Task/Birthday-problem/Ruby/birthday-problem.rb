def equalBirthdays(nSharers, groupSize, nRepetitions)
    eq = 0

    for i in 1 .. nRepetitions
        group = [0] * 365
        for j in 1 .. groupSize
            group[rand(group.length)] += 1
        end
        eq += group.any? { |n| n >= nSharers } ? 1 : 0
    end

    return (eq * 100.0) / nRepetitions
end

def main
    groupEst = 2
    for sharers in 2 .. 5
        # Coarse
        groupSize = groupEst + 1
        while equalBirthdays(sharers, groupSize, 100) < 50.0
            groupSize += 1
        end

        # Finer
        inf = (groupSize - (groupSize - groupEst) / 4.0).floor
        for gs in inf .. groupSize + 999
            eq = equalBirthdays(sharers, groupSize, 250)
            if eq > 50.0 then
                groupSize = gs
                break
            end
        end

        # Finest
        for gs in groupSize - 1 .. groupSize + 999
            eq = equalBirthdays(sharers, gs, 50000)
            if eq > 50.0 then
                groupEst = gs
                print "%d independant people in a group of %s share a common birthday. (%5.1f)\n" % [sharers, gs, eq]
                break
            end
        end
    end
end

main()
