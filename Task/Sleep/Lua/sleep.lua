function sleep (s)
	local t0 = os.time()
	repeat until os.time() - t0 >= s
end

local seconds
repeat  -- Keep asking until input is a valid number
	io.write("Enter number of seconds to sleep: ")
	seconds = tonumber(io.read())
until seconds ~= nil
print("Sleeping...")
sleep(seconds)
print("Awake!")
