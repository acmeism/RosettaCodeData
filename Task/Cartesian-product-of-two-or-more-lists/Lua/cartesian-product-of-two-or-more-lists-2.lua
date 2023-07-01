local function cartesian_product(sets)
  local result = {}
  local set_count = #sets
--[[ I believe that this should make the below go very slightly faster, because it doesn't need to lookup yield in coroutine each time it
     yields, though perhaps the compiler optimises the lookup away? ]]
  local yield = coroutine.yield
  local function descend(depth)
    if depth == set_count then
      for k,v in pairs(sets[depth]) do
        result[depth] = v
        yield(result)
      end
    else
      for k,v in pairs(sets[depth]) do
        result[depth] = v
        descend(depth + 1)
      end
    end
  end
  return coroutine.wrap(function() descend(1) end)
end

--- tests
local test_cases = {
  {{1, 2}, {3, 4}},
  {{3, 4}, {1, 2}},
  {{1776, 1789}, {7, 12}, {4, 14, 23}, {0,1}},
  {{1,2,3}, {30}, {500, 100}},
  {{1,2,3}, {}, {500, 100}}
}

local function format_nested_list(list)
  if list[1] and type(list[1]) == "table" then
    local formatted_items = {}
    for i, item in ipairs(list) do
      formatted_items[i] = format_nested_list(item)
    end
    return format_nested_list(formatted_items)
  else
    return "{" .. table.concat(list, ",") .. "}"
  end
end

for _,test_case in ipairs(test_cases) do
  print(format_nested_list(test_case))
  for product in cartesian_product(test_case) do
    print("  " .. format_nested_list(product))
  end
end
