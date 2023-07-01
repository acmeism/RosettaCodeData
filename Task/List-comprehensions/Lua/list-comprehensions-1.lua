LC={}
LC.__index = LC

function LC:new(o)
  o = o or {}
  setmetatable(o, self)
  return o
end

function LC:add_iter(func)
  local prev_iter = self.iter
  self.iter = coroutine.wrap(
    (prev_iter == nil) and (function() func{} end)
    or (function() for arg in prev_iter do func(arg) end end))
  return self
end

function maybe_call(maybe_func, arg)
  if type(maybe_func) == "function" then return maybe_func(arg) end
  return maybe_func
end

function LC:range(key, first, last)
  return self:add_iter(function(arg)
    for value=maybe_call(first, arg), maybe_call(last, arg) do
      arg[key] = value
      coroutine.yield(arg)
    end
  end)
end

function LC:where(pred)
  return self:add_iter(function(arg) if pred(arg) then coroutine.yield(arg) end end)
end
