local df = function (t, y)
-- derivative of function by value y at time t
	return t*y^0.5
end

local dt = 0.1
local y = 1

print ("t", "realY"..'     ', "y", '		'.."error")
print ("---", "-------"..'     ', "---------------", '	'.."--------------------")

for i = 0, 100 do
	local t = i*dt
	if t%1 == 0 then
		local realY = (t*t+4)^2/16
		print (t, realY..'     ', y, '	'..realY-y)
	end
	local dy1 = df(t, y)
	local dy2 = df(t+dt/2, y+dt/2*dy1)
	local dy3 = df(t+dt/2, y+dt/2*dy2)
	local dy4 = df(t+dt, y+dt*dy3)
	y = y + dt*(dy1+2*dy2+2*dy3+dy4)/6
end
