local expressionsLength = 0
function compareExpressionBySum(a, b)
    return a.sum - b.sum
end

local countSumsLength = 0
function compareCountSumsByCount(a, b)
    return a.counts - b.counts
end

function evaluate(code)
    local value = 0
    local number = 0
    local power = 1
    for k=9,1,-1 do
        number = power*k + number
        local mod = code % 3
        if mod == 0 then
            -- ADD
            value = value + number
            number = 0
            power = 1
        elseif mod == 1 then
            -- SUB
            value = value - number
            number = 0
            power = 1
        elseif mod == 2 then
            -- JOIN
            power = 10 * power
        else
            print("This should not happen.")
        end
        code = math.floor(code / 3)
    end
    return value
end

function printCode(code)
    local a = 19683
    local b = 6561
    local s = ""
    for k=1,9 do
        local temp = math.floor((code % a) / b)
        if temp == 0 then
            -- ADD
            if k>1 then
                s = s .. '+'
            end
        elseif temp == 1 then
            -- SUB
            s = s .. '-'
        end
        a = b
        b = math.floor(b/3)
        s = s .. tostring(k)
    end
    print("\t"..evaluate(code).." = "..s)
end

-- Main
local nexpr = 13122

print("Show all solutions that sum to 100")
for i=0,nexpr-1 do
    if evaluate(i) == 100 then
        printCode(i)
    end
end
print()

print("Show the sum that has the maximum number of solutions")
local nbest = -1
for i=0,nexpr-1 do
    local test = evaluate(i)
    if test>0 then
        local ntest = 0
        for j=0,nexpr-1 do
            if evaluate(j) == test then
                ntest = ntest + 1
            end
            if ntest > nbest then
                best = test
                nbest = ntest
            end
        end
    end
end
print(best.." has "..nbest.." solutions\n")

print("Show the lowest positive number that can't be expressed")
local code = -1
for i=0,123456789 do
    for j=0,nexpr-1 do
        if evaluate(j) == i then
            code = j
            break
        end
    end
    if evaluate(code) ~= i then
        code = i
        break
    end
end
print(code.."\n")

print("Show the ten highest numbers that can be expressed")
local limit = 123456789 + 1
for i=1,10 do
    local best=0
    for j=0,nexpr-1 do
        local test = evaluate(j)
        if (test<limit) and (test>best) then
            best = test
        end
    end
    for j=0,nexpr-1 do
        if evaluate(j) == best then
            printCode(j)
        end
    end
    limit = best
end
