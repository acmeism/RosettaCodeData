-- History variables in Lua 6/12/2020 db
local HistoryVariable = {
  new = function(self)
    return setmetatable({history={}},self)
  end,
  get = function(self)
    return self.history[#self.history]
  end,
  set = function(self, value)
    self.history[#self.history+1] = value
  end,
  undo = function(self)
    self.history[#self.history] = nil
  end,
}
HistoryVariable.__index = HistoryVariable

local hv = HistoryVariable:new()
print("defined:", hv)
print("value is:", hv:get())
--
hv:set(1); print("set() to:", hv:get())
hv:set(2); print("set() to:", hv:get())
hv:set(3); print("set() to:", hv:get())
--
print("history:", table.concat(hv.history,","))
--
hv:undo(); print("undo() to:", hv:get())
hv:undo(); print("undo() to:", hv:get())
hv:undo(); print("undo() to:", hv:get())
