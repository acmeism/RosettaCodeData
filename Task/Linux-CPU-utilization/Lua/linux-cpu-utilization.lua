-- No hardcoded interval, hit ENTER to create interval, b***h!

-- Helper function: splits string "s" into a table based on "separator"
local function split(s, separator)
    local r = {} -- Result table
    local currentSubString = s

    while currentSubString ~= "" do
        -- Find separator in the current substring
        local currentSeparatorStartIndex, currentSeparatorEndIndex = currentSubString:find(separator, 1, true)
        if not currentSeparatorStartIndex then
            -- No more separators, insert the rest and break
            table.insert(r, currentSubString)
            break
        end
        -- Insert substring before separator
        local currentItem = currentSubString:sub(1, currentSeparatorStartIndex-1)
        table.insert(r, currentItem)
        -- Update current substring to everything after separator
        currentSubString = currentSubString:sub(currentSeparatorEndIndex+1)
    end

    return r
end

-- Helper function: sums all arguments passed to it
local function sum(...)
    local r = 0
    for _, v in ipairs({...}) do
        r = r + v
    end
    return r
end

-- Variables to store previous idle and total CPU times
local lastIdle = 0
local lastTotal = 0
local fields = {} -- Table to store parsed CPU times
local data -- To hold raw data read from "/proc/stat"

-- Repeatedly read CPU usage and calculate utilisation
while true do
    -- Read the first line from "/proc/stat" (overall CPU times)
    data = split(io.open("/proc/stat", "r"):read("a"), "\n")[1]

    -- Parse the first word and the following numbers (times) from the line
    for first, times in string.gmatch(data, "([%a%d]+)%s+([%d+ ?]+)") do
        -- Split the list of times and insert each one into "fields"
        for _, n in ipairs(split(times, " ")) do
            table.insert(fields, tonumber(n)/1) -- Convert to number
        end
    end

    local idle = fields[4] -- The fourth field is "idle" time
    local total = sum(table.unpack(fields)) -- "total" is the sum of all CPU times
    -- Deltas: change in "idle" and "total" since last check
    local idleDelta = idle - lastIdle
    local totalDelta = total - lastTotal
    -- Update last known "idle" and "total"
    lastIdle, lastTotal = idle, total
    -- Calculate CPU utilisation percentage
    local utilisation = 100.0 * (1.0 - idleDelta / totalDelta)

    -- Output CPU utilisation and wait for user to hit ENTER
    io.write(string.format("%5.1f%%", utilisation).."\t|\tHit \"ENTER\" to continue")
    io.read()

    -- Clear "fields" for next loop
    fields = {}
end
