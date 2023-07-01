function square(x)
    return x * x
end

function mean(a)
    local s = 0
    local c = 0
    for i,v in pairs(a) do
        s = s + v
        c = c + 1
    end
    return s / c
end

function averageSquareDiff(a, predictions)
    local results = {}
    for i,x in pairs(predictions) do
        table.insert(results, square(x - a))
    end
    return mean(results)
end

function diversityTheorem(truth, predictions)
    local average = mean(predictions)
    print("average-error: " .. averageSquareDiff(truth, predictions))
    print("crowd-error: " .. square(truth - average))
    print("diversity: " .. averageSquareDiff(average, predictions))
end

function main()
    diversityTheorem(49, {48, 47, 51})
    diversityTheorem(49, {48, 47, 51, 42})
end

main()
