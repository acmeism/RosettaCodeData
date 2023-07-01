range = { degrees=360, gradians=400, mils=6400, radians=2.0*math.pi }
function convert(value, fromunit, tounit)
  return math.fmod(value * range[tounit] / range[fromunit], range[tounit])
end

testvalues = { -2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000 }
testunits = { "degrees", "gradians", "mils", "radians" }
print(string.format("%15s  %8s = %15s  %15s  %15s  %15s", "VALUE", "UNIT", "DEGREES", "GRADIANS", "MILS", "RADIANS"))
for _, value in ipairs(testvalues) do
  for _, fromunit in ipairs(testunits) do
    local d = convert(value, fromunit, "degrees")
    local g = convert(value, fromunit, "gradians")
    local m = convert(value, fromunit, "mils")
    local r = convert(value, fromunit, "radians")
    print(string.format("%15.7f  %8s = %15.7f  %15.7f  %15.7f  %15.7f", value, fromunit, d, g, m, r))
  end
end
