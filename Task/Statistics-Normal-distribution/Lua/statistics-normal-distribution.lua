function gaussian (mean, variance)
    return  math.sqrt(-2 * variance * math.log(math.random())) *
            math.cos(2 * math.pi * math.random()) + mean
end

function mean (t)
    local sum = 0
    for k, v in pairs(t) do
        sum = sum + v
    end
    return sum / #t
end

function std (t)
    local squares, avg = 0, mean(t)
    for k, v in pairs(t) do
        squares = squares + ((avg - v) ^ 2)
    end
    local variance = squares / #t
    return math.sqrt(variance)
end

function showHistogram (t)
    local lo = math.ceil(math.min(unpack(t)))
    local hi = math.floor(math.max(unpack(t)))
    local hist, barScale = {}, 200
    for i = lo, hi do
        hist[i] = 0
        for k, v in pairs(t) do
            if math.ceil(v - 0.5) == i then
                hist[i] = hist[i] + 1
            end
        end
        io.write(i .. "\t" .. string.rep('=', hist[i] / #t * barScale))
        print(" " .. hist[i])
    end
end

math.randomseed(os.time())
local t, average, variance = {}, 50, 10
for i = 1, 1000 do
    table.insert(t, gaussian(average, variance))
end
print("Mean:", mean(t) .. ", expected " .. average)
print("StdDev:", std(t) .. ", expected " .. math.sqrt(variance) .. "\n")
showHistogram(t)
