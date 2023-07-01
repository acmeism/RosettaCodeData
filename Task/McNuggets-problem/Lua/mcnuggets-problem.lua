function range(A,B)
    return function()
        return coroutine.wrap(function()
            for i = A, B do coroutine.yield(i) end
        end)
    end
end

function filter(stream, f)
    return function()
        return coroutine.wrap(function()
            for i in stream() do
                if f(i) then coroutine.yield(i) end
            end
        end)
    end
end

function triple(s1, s2, s3)
    return function()
        return coroutine.wrap(function()
            for x in s1() do
                for y in s2() do
                    for z in s3() do
                        coroutine.yield{x,y,z}
                    end
                end
            end
        end)
    end
end

function apply(f, stream)
    return function()
        return coroutine.wrap(function()
            for T in stream() do
                coroutine.yield(f(table.unpack(T)))
            end
        end)
    end
end

function exclude(s1, s2)
    local exlusions = {} for x in s1() do exlusions[x] = true end
    return function()
        return coroutine.wrap(function()
            for x in s2() do
                if not exlusions[x] then
                    coroutine.yield(x)
                end
            end
        end)
    end
end

function maximum(stream)
    local M = math.mininteger
    for x in stream() do
        M = math.max(M, x)
    end
    return M
end

local N = 100
local A, B, C = 6, 9, 20

local Xs = filter(range(0, N), function(x) return x  % A == 0 end)
local Ys = filter(range(0, N), function(x) return x  % B == 0 end)
local Zs = filter(range(0, N), function(x) return x  % C == 0 end)
local sum = filter(apply(function(x, y, z) return x + y + z end, triple(Xs, Ys, Zs)), function(x) return x <= N end)

print(maximum(exclude(sum, range(1, N))))
