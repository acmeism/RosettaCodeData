function _deepcopy(o, tables)

  if type(o) ~= 'table' then
    return o
  end

  if tables[o] ~= nil then
    return tables[o]
  end

  local new_o = {}
  tables[o] = new_o

  for k, v in next, o, nil do
    local new_k = _deepcopy(k, tables)
    local new_v = _deepcopy(v, tables)
    new_o[new_k] = new_v
  end

  return new_o
end

function deepcopy(o)
  return _deepcopy(o, {})
end
