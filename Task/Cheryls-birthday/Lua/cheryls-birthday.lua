-- Cheryl's Birthday in Lua 6/15/2020 db

local function Date(mon,day)
  return { mon=mon, day=day, valid=true }
end

local choices = {
  Date("May", 15), Date("May", 16), Date("May", 19),
  Date("June", 17), Date("June", 18),
  Date("July", 14), Date("July", 16),
  Date("August", 14), Date("August", 15), Date("August", 17)
}

local function apply(t, f)
  for k, v in ipairs(t) do
    f(k, v)
  end
end

local function filter(t, f)
  local result = {}
  for k, v in ipairs(t) do
    if f(k, v) then
      result[#result+1] = v
    end
  end
  return result
end

local function map(t, f)
  local result = {}
  for k, v in ipairs(t) do
    result[#result+1] = f(k, v)
  end
  return result
end

local function count(t) return #t end
local function isvalid(k, v) return v.valid end
local function invalidate(k, v) v.valid = false end
local function remaining() return filter(choices, isvalid) end

local function listValidChoices()
  print("   " .. table.concat(map(remaining(), function(k, v) return v.mon .. " " .. v.day end), ", "))
  print()
end

print("Cheryl offers these ten choices:")
listValidChoices()

print("1) Albert knows that Bernard also cannot yet know, so cannot be a month with a unique day, leaving:")
apply(remaining(), function(k, v)
  if count(filter(choices, function(k2, v2) return v.day==v2.day end)) == 1 then
    apply(filter(remaining(), function(k2, v2) return v.mon==v2.mon end), invalidate)
  end
end)
listValidChoices()

print("2) After Albert's revelation, Bernard now knows, so day must be unique, leaving:")
apply(remaining(), function(k, v)
  local subset = filter(remaining(), function(k2, v2) return v.day==v2.day end)
  if count(subset) > 1 then apply(subset, invalidate) end
end)
listValidChoices()

print("3) After Bernard's revelation, Albert now knows, so month must be unique, leaving only:")
apply(remaining(), function(k, v)
  local subset = filter(remaining(), function(k2, v2) return v.mon==v2.mon end)
  if count(subset) > 1 then apply(subset, invalidate) end
end)
listValidChoices()
