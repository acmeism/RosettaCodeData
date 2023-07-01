local function cartesian_product(sets)
  local item_counts = {}
  local indices = {}
  local results = {}
  local set_count = #sets
  local combination_count = 1

  for set_index=set_count, 1, -1 do
    local set = sets[set_index]
    local item_count = #set
    item_counts[set_index] = item_count
    indices[set_index] = 1
    results[set_index] = set[1]
    combination_count = combination_count * item_count
  end

  local combination_index = 0

  return function()
    if combination_index >= combination_count then return end -- no more output

    if combination_index == 0 then goto skip_update end -- skip first index update

    indices[set_count] = indices[set_count] + 1

    for set_index=set_count, 1, -1 do -- update index list
      local set = sets[set_index]
      local index = indices[set_index]
      if index <= item_counts[set_index] then
        results[set_index] = set[index]
        break -- no further update needed
      else -- propagate item_counts overflow
        results[set_index] = set[1]
        indices[set_index] = 1
        if set_index > 1 then
          indices[set_index - 1] = indices[set_index - 1] + 1
        end
      end
    end

    ::skip_update::

    combination_index = combination_index + 1

    return combination_index, results
  end
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
  for i, product in cartesian_product(test_case) do
    print(i, format_nested_list(product))
  end
end
