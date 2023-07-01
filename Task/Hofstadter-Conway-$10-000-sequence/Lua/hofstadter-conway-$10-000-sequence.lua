local fmt, write=string.format,io.write
local hof=coroutine.wrap(function()
	local yield=coroutine.yield
	local a={1,1}
	yield(a[1], 1)
	yield(a[2], 2)
	local n=a[#a]
	repeat
		n=a[n]+a[1+#a-n]
		a[#a+1]=n
		yield(n, #a)
	until false
end)

local mallows, mdiv=0,0
for p=1,20 do
	local max, div, num, last, fdiv=0,0,0,0,0
	for i=2^(p-1),2^p-1 do
		h,n=hof()
		div=h/n
		if div>max then
			max=div
			num=n
		end
		if div>0.55 then
			last=n
			fdiv=div
		end
	end
	write(fmt("From 2^%-2d to 2^%-2d the max is %.4f the %6dth Hofstadter number.\n",
		p-1, p, max, num))
	if max>.55 and p>4 then
		mallows, mdiv=last, fdiv
	end
end
write("So Mallows number is ", mallows, " with ", fmt("%.4f",mdiv), ", yay, just wire me my $10000 now!\n")
