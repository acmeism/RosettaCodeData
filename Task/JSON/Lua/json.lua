local json = require("json")

local json_data = [=[[
    42,
    3.14159,
    [ 2, 4, 8, 16, 32, 64, "apples", "bananas", "cherries" ],
    { "H": 1, "He": 2, "X": null, "Li": 3 },
    null,
    true,
    false
]]=]

print("Original JSON: " .. json_data)
local data = json.decode(json_data)
json.util.printValue(data, 'Lua')
print("JSON re-encoded: " .. json.encode(data))

local data = {
    42,
    3.14159,
    {
        2, 4, 8, 16, 32, 64,
        "apples",
        "bananas",
        "cherries"
    },
    {
        H = 1,
        He = 2,
        X = json.util.null(),
        Li = 3
    },
    json.util.null(),
    true,
    false
}

print("JSON from new Lua data: " .. json.encode(data))
