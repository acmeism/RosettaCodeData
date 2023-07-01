local function new(_, ...)
  local r = {}
  local s = setmetatable({}, {
    -- API operations
    __index = {

      -- single value insertion
      insert = function(s, v)
        if not r[v] then
          table.insert(s, v)
          r[v] = #s
        end
        return s
      end,

      -- single value removal
      remove = function(s, v)
        local i = r[v]
        if i then
          r[v] = nil
          local t = table.remove(s)
          if t ~= v then
            r[t] = i
            s[i] = t
          end
        end
        return s
      end,

      -- multi-value insertion
      batch_insert = function(s, ...)
        for _,v in pairs {...} do
          s:insert(v)
        end
        return s
      end,

      -- multi-value removal
      batch_remove = function(s, ...)
        for _,v in pairs {...} do
          s:remove(v)
        end
        return s
      end,

      -- membership test
      has = function(s, e)
        return r[e] ~= nil
      end
    },

    -- set manipulation operators

    -- union
    __add = function(s1, s2)
      r = set()
      r:batch_insert(table.unpack(s1))
      r:batch_insert(table.unpack(s2))
      return r
    end,

    -- subtraction
    __sub = function(s1, s2)
      r = set()
      r:batch_insert(table.unpack(s1))
      r:batch_remove(table.unpack(s2))
      return r
    end,

    -- intersection
    __mul = function(s1, s2)
      r = set()
      for _,v in ipairs(s1) do
        if s2:has(v) then
          r:insert(v)
        end
      end
      return r
    end,

    -- equality
    __eq = function(s1, s2)
      if #s1 ~= #s2 then return false end
      for _,v in ipairs(s1) do
        if not s2:has(v) then return false end
      end
      return true
    end,

    -- proper subset
    __lt = function(s1, s2)
      if s1 == s2 then return false end
      for _,v in ipairs(s1) do
        if not s2:has(v) then return false end
      end
      return true
    end,

    -- subset
    __lte = function(s1, s2)
      return (s1 == s2) or (s1 < s2)
    end,

    -- metatable type tag
    __type__ = 'set'
  })
  s:batch_insert(...)
  return s
end

return setmetatable({}, { __call = new })
