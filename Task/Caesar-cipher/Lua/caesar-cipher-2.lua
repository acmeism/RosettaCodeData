local memo = {}

local function make_table(k)
    local t = {}
    local a, A = ('a'):byte(), ('A'):byte()

    for i = 0,25 do
        local  c = a + i
        local  C = A + i
        local rc = a + (i+k) % 26
        local RC = A + (i+k) % 26
        t[c], t[C] = rc, RC
    end

    return t
end

local function caesar(str, k, decode)
    k = (decode and -k or k) % 26

    local t = memo[k]
    if not t then
        t = make_table(k)
        memo[k] = t
    end

    local res_t = { str:byte(1,-1) }
    for i,c in ipairs(res_t) do
        res_t[i] = t[c] or c
    end
    return string.char(unpack(res_t))
end
