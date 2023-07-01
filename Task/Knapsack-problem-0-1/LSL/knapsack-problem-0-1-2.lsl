items = {
    {"map", 9, 150},
    {"compass", 13, 35},
    {"water", 153, 200},
    {"sandwich", 50, 160},
    {"glucose", 15, 60},
    {"tin", 68, 45},
    {"banana", 27, 60},
    {"apple", 39,  40},
    {"cheese", 23, 30},
    {"beer", 52, 10},
    {"suntan cream", 11, 70},
    {"camera", 32, 30},
    {"t-shirt", 24, 15},
    {"trousers", 48, 10},
    {"umbrella", 73, 40},
    {"waterproof trousers", 42, 70},
    {"waterproof overclothes", 43, 75},
    {"note-case", 22, 80},
    {"sunglasses", 7, 20},
    {"towel", 18, 12},
    {"socks", 4, 50},
    {"book", 30, 10},
}

local unpack = table.unpack

function m(i, w)
    if i<1 or w==0 then
        return 0, {}
    else
        local _, wi, vi = unpack(items[i])
        if wi > w then
            return mm(i - 1, w)
        else
            local vn, ln = mm(i - 1, w)
            local vy, ly = mm(i - 1, w - wi)
            if vy + vi > vn then
                return vy + vi, { i, ly }
            else
                return vn, ln
            end
        end
    end
end

local memo, mm_calls = {}, 0
function mm(i, w) -- memoization function for m
    mm_calls = mm_calls + 1
    local key = 10000*i + w
    local result = memo[key]
    if not result then
        result = { m(i, w) }
        memo[key] = result
    end
    return unpack(result)
end

local total_value, index_list = m(#items, 400)

function list_items(head) -- makes linked list iterator function
    return function()
        local item, rest = unpack(head)
        head = rest
        return item
    end
end

local names = {}
local total_weight = 0
for i in list_items(index_list) do
    local name, weight = unpack(items[i])
    table.insert(names, 1, name)
    total_weight = total_weight + weight
end

local function printf(fmt, ...) print(string.format(fmt, ...)) end
printf("items to pack: %s", table.concat(names, ", "))
printf("total value: %d", total_value)
printf("total weight: %d", total_weight)

-- out of curiosity
local count = 0
for k,v in pairs(memo) do count = count + 1 end
printf("\n(memo count: %d; mm call count: %d)", count, mm_calls)
