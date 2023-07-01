-- Dataset declaration
local cityPops = {
    {name = "Lagos", population = 21.0},
    {name = "Cairo", population = 15.2},
    {name = "Kinshasa-Brazzaville", population = 11.3},
    {name = "Greater Johannesburg", population = 7.55},
    {name = "Mogadishu", population = 5.85},
    {name = "Khartoum-Omdurman", population = 4.98},
    {name = "Dar Es Salaam", population = 4.7},
    {name = "Alexandria", population = 4.58},
    {name = "Abidjan", population = 4.4},
    {name = "Casablanca", population = 3.98}
}

-- Function to search a dataset using a custom match function
function recordSearch (dataset, matchFunction)
    local returnValue
    for index, element in pairs(dataset) do
        returnValue = matchFunction(index, element)
        if returnValue then return returnValue end
    end
    return nil
end

-- Main procedure
local testCases = {
    function (i, e) if e.name == "Dar Es Salaam" then return i - 1 end end,
    function (i, e) if e.population < 5 then return e.name end end,
    function (i, e) if e.name:sub(1, 1) == "A" then return e.population end end
}
for _, func in pairs(testCases) do print(recordSearch(cityPops, func)) end
