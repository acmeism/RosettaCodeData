-- History variables in Lua 6/12/2020 db
local function HistoryVariable()
  local history = {}
  return {
    get = function()
      return history[#history]
    end,
    set = function(value)
      history[#history+1] = value
    end,
    undo = function()
      history[#history] = nil
    end,
    getHistory = function()
      local clone = {}
      for k,v in pairs(history) do clone[k]=v end
      return clone
    end
  }
end

local hv = HistoryVariable()
print("defined:", hv)
print("value is:", hv.get())
--
hv.set(1); print("set() to:", hv.get())
hv.set(2); print("set() to:", hv.get())
hv.set(3); print("set() to:", hv.get())
--
print("history:", table.concat(hv.getHistory(),","))
--
hv.undo(); print("undo() to:", hv.get())
hv.undo(); print("undo() to:", hv.get())
hv.undo(); print("undo() to:", hv.get())
