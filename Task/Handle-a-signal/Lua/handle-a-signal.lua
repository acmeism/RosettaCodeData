local start_date = os.time()

local loop = true
local Exit = function ()
	print()
	loop = false
end

local posix = require"posix"
posix.signal(posix.SIGINT, Exit)
posix.signal(posix.SIGQUIT, Exit)

local int = 0
while loop do
	int = int+1
	print(int)
	posix.time.nanosleep{tv_sec=0,tv_nsec=500*1000*1000}
end

print(os.time() - start_date)
