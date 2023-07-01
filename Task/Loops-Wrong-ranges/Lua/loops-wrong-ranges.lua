tests = {
  { -2, 2,  1, "Normal" },
  {-2,  2,  0, "Zero increment" }, -- 5.4 error
  {-2,  2, -1, "Increments away from stop value" },
  {-2,  2, 10, "First increment is beyond stop value" },
  { 2, -2,  1, "Start more than stop: positive increment" },
  { 2,  2,  1, "Start equal stop: positive increment" },
  { 2,  2, -1, "Start equal stop: negative increment" },
  { 2,  2,  0, "Start equal stop: zero increment" }, -- 5.4 error
  { 0,  0,  0, "Start equal stop equal zero: zero increment" } -- 5.4 error
}
unpack = unpack or table.unpack -- polyfill 5.2 vs 5.3
for _,test in ipairs(tests) do
  start,stop,incr,desc = unpack(test)
  io.write(string.format("%-44s (%2d, %2d, %2d) :  ",desc,start,stop,incr))
  local sta,err = pcall(function()
    local n = 0
    for i = start,stop,incr do
      io.write(string.format("%2d, ", i))
      n=n+1 if n>=10 then io.write("...") break end
    end
    io.write("\n")
  end)
  if err then io.write("RUNTIME ERROR!\n") end
end
