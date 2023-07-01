local seconds = os.clock

local integrator = {
  new = function(self, fn)
    return setmetatable({fn=fn,t0=seconds(),v0=0,sum=0,nup=0},self)
  end,
  update = function(self)
    self.t1 = seconds()
    self.v1 = self.fn(self.t1)
    self.sum = self.sum + (self.v0 + self.v1) * (self.t1 - self.t0) / 2
    self.t0, self.v0, self.nup = self.t1, self.v1, self.nup+1
  end,
  input = function(self, fn) self.fn = fn end,
  output = function(self) return self.sum end,
}
integrator.__index = integrator

-- "fake multithreaded sleep()"
-- waits for "duration" seconds calling "f" at every "interval" seconds
local function sample(duration, interval, f)
  local now = seconds()
  local untilwhen, nextinterval = now+duration, now+interval
  f()
  repeat
    if seconds() >= nextinterval then f() nextinterval=nextinterval+interval end
  until seconds() >= untilwhen
end

local pi, sin = math.pi, math.sin
local ks = function(t) return sin(2.0*pi*0.5*t) end
local kz = function(t) return 0 end
local intervals = { 0.5, 0.25, 0.1, 0.05, 0.025, 0.01, 0.005, 0.0025, 0.001 }
for _,interval in ipairs(intervals) do
  local i = integrator:new(ks)
  sample(2.0, interval, function() i:update() end)
  i:input(kz)
  sample(0.5, interval, function() i:update() end)
  print(string.format("sampling interval: %f, %5d updates over 2.5s total = %.15f", interval, i.nup, i:output()))
end
