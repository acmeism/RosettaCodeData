function deepcopy(o, mode)

  if type(o) ~= 'table' then
    return o
  end

  mode = mode and mode:lower() or 'v'
  local deep_keys   = mode:find('k')
  local deep_values = mode:find('v')

  local new_t = {}
  local stack = {o}
  local tables = {[o] = new_t}

  local function copy(v)
    if type(v) ~= 'table' then
      return v
    end
    if tables[v] == nil then
      tables[v] = {}
      stack[#stack+1] = v
    end
    return tables[v]
  end

  while #stack ~= 0 do
    local t = table.remove(stack)
    local new_t = tables[t]

    for k,v in next, t, nil do
      if deep_keys   then k = copy(k) end
      if deep_values then v = copy(v) end
      new_t[k] = v
    end
  end

  return new_t
end
