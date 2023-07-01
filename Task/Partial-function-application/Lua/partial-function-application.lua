function map(f, ...)
    local t = {}
    for k, v in ipairs(...) do
        t[#t+1] = f(v)
    end
    return t
end

function timestwo(n)
    return n * 2
end

function squared(n)
    return n ^ 2
end

function partial(f, arg)
    return function(...)
        return f(arg, ...)
    end
end

timestwo_s = partial(map, timestwo)
squared_s = partial(map, squared)

print(table.concat(timestwo_s{0, 1, 2, 3}, ', '))
print(table.concat(squared_s{0, 1, 2, 3}, ', '))
print(table.concat(timestwo_s{2, 4, 6, 8}, ', '))
print(table.concat(squared_s{2, 4, 6, 8}, ', '))
