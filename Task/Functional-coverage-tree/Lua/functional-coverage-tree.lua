-- DATA:
local function node(name, weight, coverage, children)
  return { name=name, weight=weight or 1.0, coverage=coverage or 0.0, sumofweights=0, delta=0, children=children }
end

local root =
node("cleaning", nil, nil, {
  node("house1", 40, nil, {
    node("bedrooms", nil, 0.25),
    node("bathrooms", nil, nil, {
      node("bathroom1", nil, 0.5),
      node("bathroom2"),
      node("outside_lavatory", nil, 1)
    }),
    node("attic", nil, 0.75),
    node("kitchen", nil, 0.1),
    node("living_rooms", nil, nil, {
      node("lounge"),
      node("dining_room"),
      node("conservatory"),
      node("playroom",nil,1)
    }),
    node("basement"),
    node("garage"),
    node("garden", nil, 0.8)
  }),
  node("house2", 60, nil, {
    node("upstairs", nil, nil, {
      node("bedrooms", nil, nil, {
        node("suite_1"),
        node("suite_2"),
        node("bedroom_3"),
        node("bedroom_4")
      }),
      node("bathroom"),
      node("toilet"),
      node("attics", nil, 0.6)
    }),
    node("groundfloor", nil, nil, {
      node("kitchen"),
      node("living_rooms", nil, nil, {
        node("lounge"),
        node("dining_room"),
        node("conservatory"),
        node("playroom")
      }),
      node("wet_room_&_toilet"),
      node("garage"),
      node("garden", nil, 0.9),
      node("hot_tub_suite", nil, 1)
    }),
    node("basement", nil, nil, {
      node("cellars", nil, 1),
      node("wine_cellar", nil, 1),
      node("cinema", nil, 0.75)
    })
  })
})

-- TASK:
local function calccover(node)
  if (node.children) then
    local cnt, sum = 0, 0
    for _,child in ipairs(node.children) do
      local ccnt, csum = calccover(child)
      cnt, sum = cnt+ccnt, sum+csum
    end
    node.coverage = sum/cnt
    node.sumofweights = cnt -- just as prep for extra credit
  end
  return node.weight, node.coverage * node.weight
end
calccover(root)

-- EXTRA CREDIT:
local function calcdelta(node, power)
  node.delta = (1.0 - node.coverage) * power
  if (node.children) then
    for _,child in ipairs(node.children) do
      calcdelta(child, power * child.weight / node.sumofweights)
    end
  end
end
calcdelta(root,1)

-- OUTPUT:
local function printnode(node, space)
  print(string.format("%-32s|  %3.f   | %8.6f | %8.6f |", string.rep(" ",space)..node.name, node.weight, node.coverage, node.delta))
  if node.children then
    for _,child in ipairs(node.children) do printnode(child,space+4) end
  end
end
print("NAME_HIERARCHY                  |WEIGHT  |COVERAGE  |DELTA     |")
printnode(root,0)
