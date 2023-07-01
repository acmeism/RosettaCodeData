#!/usr/bin/env luajit
local gmp = require 'gmp' ('libgmp')
local ffi = require'ffi'
local mpz, mpq = gmp.types.z, gmp.types.q
local function mpq_for(buf, op, n)
	for i=0,n-1 do
		op(buf[i])
	end
end
local function bernoulli(rop, n)
	local a=ffi.new("mpq_t[?]", n+1)
	mpq_for(a, gmp.q_init, n+1)

	for m=0,n do
		gmp.q_set_ui(a[m],1, m+1)
		for j=m,1,-1 do
			gmp.q_sub(a[j-1], a[j], a[j-1])
			gmp.q_set_ui(rop, j, 1)
			gmp.q_mul(a[j-1], a[j-1], rop)
		end
	end
	gmp.q_set(rop,a[0])
	mpq_for(a, gmp.q_clear, n+1)
end
do --MAIN
	local rop=mpq()
	local n,d=mpz(),mpz()
	gmp.q_init(rop)
	gmp.z_inits(n, d)
	local to=arg[1] and tonumber(arg[1]) or 60
	local from=arg[2] and tonumber(arg[2]) or 0
	if from~=0 then to,from=from,to end


	for i=from,to do
		bernoulli(rop, i)
		if gmp.q_cmp_ui(rop, 0, 1)~=0 then
			gmp.q_get_num(n, rop)
			gmp.q_get_den(d, rop)
			gmp.printf("B(%-2g) = %44Zd / %Zd\n", i, n, d)
		end
	end
	gmp.z_clears(n,d)
	gmp.q_clear(rop)
end
