Stack = {}

function Stack:Create()
  local stack = {}

  function stack:push(item)
    self[#self + 1] = item
  end

  function stack:pop()
    local item = self[#self]
    self[#self] = nil
    return item
  end

  return stack
end
