function print_count(t)
    local cnt = 0
    for k,v in pairs(t) do
        cnt = cnt + 1
    end
    print(cnt .. ' candidates')
end

function make_pair(a,b)
    local t = {}
    table.insert(t, a) -- 1
    table.insert(t, b) -- 2
    return t
end

function setup()
    local candidates = {}
    for x = 2, 98 do
        for y = x + 1, 98 do
            if x + y <= 100 then
                local p = make_pair(x, y)
                table.insert(candidates, p)
            end
        end
    end
    return candidates
end

function remove_by_sum(candidates, sum)
    for k,v in pairs(candidates) do
        local s = v[1] + v[2]
        if s == sum then
            table.remove(candidates, k)
        end
    end
end

function remove_by_prod(candidates, prod)
    for k,v in pairs(candidates) do
        local p = v[1] * v[2]
        if p == prod then
            table.remove(candidates, k)
        end
    end
end

function statement1(candidates)
    local unique = {}
    for k,v in pairs(candidates) do
        local prod = v[1] * v[2]
        if unique[prod] ~= nil then
            unique[prod] = unique[prod] + 1
        else
            unique[prod] = 1
        end
    end

    local done
    repeat
        done = true
        for k,v in pairs(candidates) do
            local prod = v[1] * v[2]
            if unique[prod] == 1 then
                local sum = v[1] + v[2]
                remove_by_sum(candidates, sum)
                done = false
                break
            end
        end
    until done
end

function statement2(candidates)
    local unique = {}
    for k,v in pairs(candidates) do
        local prod = v[1] * v[2]
        if unique[prod] ~= nil then
            unique[prod] = unique[prod] + 1
        else
            unique[prod] = 1
        end
    end

    local done
    repeat
        done = true
        for k,v in pairs(candidates) do
            local prod = v[1] * v[2]
            if unique[prod] > 1 then
                remove_by_prod(candidates, prod)
                done = false
                break
            end
        end
    until done
end

function statement3(candidates)
    local unique = {}
    for k,v in pairs(candidates) do
        local sum = v[1] + v[2]
        if unique[sum] ~= nil then
            unique[sum] = unique[sum] + 1
        else
            unique[sum] = 1
        end
    end

    local done
    repeat
        done = true
        for k,v in pairs(candidates) do
            local sum = v[1] + v[2]
            if unique[sum] > 1 then
                remove_by_sum(candidates, sum)
                done = false
                break
            end
        end
    until done
end

function main()
    local candidates = setup()
    print_count(candidates)

    statement1(candidates)
    print_count(candidates)

    statement2(candidates)
    print_count(candidates)

    statement3(candidates)
    print_count(candidates)

    for k,v in pairs(candidates) do
        local sum = v[1] + v[2]
        local prod = v[1] * v[2]
        print("a=" .. v[1] .. ", b=" .. v[2] .. "; S=" .. sum .. ", P=" .. prod)
    end
end

main()
