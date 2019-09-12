-- Gets the output of given program as string
-- Note that io.popen is not available on all platforms
local function getOutput(prog)
    local file = assert(io.popen(prog, "r"))
    local output = assert(file:read("*a"))
    file:close()
    return output
end

-- Iterates files in given directory
local function files(directory, recursively)
    -- Use windows" dir command
    local directory = directory:gsub("/", "\\")
    local filenames = getOutput(string.format("dir %s %s/B/A:A", directory, recursively and '/S' or ''))

    -- Function to be called in "for filename in files(directory)"
    return coroutine.wrap(function()
        for filename in filenames:gmatch("([^\r\n]+)") do
            coroutine.yield(filename)
        end
    end)
end

-- Walk "C:/Windows" looking for executables
local directory = "C:/Windows"
local pattern = ".*%.exe$" -- for finding executables
for filename in files(directory, true) do
    if filename:match(pattern) then
        print(filename)
    end
end
