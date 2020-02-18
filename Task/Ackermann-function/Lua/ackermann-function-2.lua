#!/usr/bin/env luajit
local gmp = require 'gmp' ('libgmp')
local mpz, 		z_mul, 		z_add, 		z_add_ui, 		z_set_d =
	gmp.types.z, gmp.z_mul,	gmp.z_add,	gmp.z_add_ui, 	gmp.z_set_d
local z_cmp, 	z_cmp_ui, 		z_init_d, 			z_set=
	gmp.z_cmp,	gmp.z_cmp_ui, 	gmp.z_init_set_d, 	gmp.z_set
local printf = gmp.printf

local function ack(i,n)
	local nxt=setmetatable({},  {__index=function(t,k) local z=mpz() z_init_d(z, 0) t[k]=z return z end})
	local goal=setmetatable({}, {__index=function(t,k) local o=mpz() z_init_d(o, 1) t[k]=o return o end})
	goal[i]=mpz() z_init_d(goal[i], -1)
	local v=mpz() z_init_d(v, 0)
	local ic
	local END=n+1
	local ntmp,gtmp
	repeat
		ic=0
		ntmp,gtmp=nxt[ic], goal[ic]
		z_add_ui(v, ntmp, 1)
		while z_cmp(ntmp, gtmp) == 0 do
			z_set(gtmp,v)
			z_add_ui(ntmp, ntmp, 1)
			nxt[ic], goal[ic]=ntmp, gtmp
			ic=ic+1
			ntmp,gtmp=nxt[ic], goal[ic]
		end
		z_add_ui(ntmp, ntmp, 1)
		nxt[ic]=ntmp
	until z_cmp_ui(nxt[i], END) == 0
	return v
end

if #arg<1 then
	print("Ackermann: "..arg[0].." <num1> [num2]")
else
	printf("%Zd\n", ack(tonumber(arg[1]), arg[2] and tonumber(arg[2]) or 0))
end
