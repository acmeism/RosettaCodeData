SECONDS_IN_A_DAY = 60 * 60 * 24

-- Convert date string as YYYY-MM-DD to Epoch time.
function parseDate (str)
  local y, m, d = string.match(str, "(%d+)-(%d+)-(%d+)")
  return os.time({year = y, month = m, day = d})
end

-- Main procedure
io.write("Enter date 1: ")
local d1 = parseDate(io.read())
io.write("Enter date 2: ")
local d2 = parseDate(io.read())
local diff = math.ceil(os.difftime(d2, d1) / SECONDS_IN_A_DAY)
print("There are " .. diff .. " days between these dates.")
