local http = require("http")

http.createServer(function(req, res)
	print(("Connection from %s"):format(req.socket:address().ip))

	local chunks = {}
	local function dumpChunks()
		for i=1,#chunks do
			res:write(table.remove(chunks, 1))
		end
	end

	req:on("data", function(data)
		for line, nl in data:gmatch("([^\n]+)(\n?)") do
			if nl == "\n" then
				dumpChunks()
				res:write(line)
				res:write("\n")
			else
				table.insert(chunks, line)
			end
		end
	end)

	req:on("end", function()
		dumpChunks()
		res:finish()
	end)
end):listen(12321, "127.0.0.1")

print("Server running at http://127.0.0.1:12321/")
