base = {name="Rocket Skates", price=12.75, color="yellow"}
update = {price=15.25, color="red", year=1974}

--[[ clone the base data ]]--
result = {}
for key,val in pairs(base) do
    result[key] = val
end

--[[ copy in the update data ]]--
for key,val in pairs(update) do
    result[key] = val
end

--[[ print the result ]]--
for key,val in pairs(result) do
    print(string.format("%s: %s", key, val))
end
