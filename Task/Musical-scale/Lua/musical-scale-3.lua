beep = require"alien".kernel32.Beep
beep:types{ret='long', abi='stdcall', 'long', 'long'}
for _,step in ipairs{0,2,4,5,7,9,11,12} do
  beep(math.floor(261.63 * 2^(step/12) + 0.5), 1000)
end
