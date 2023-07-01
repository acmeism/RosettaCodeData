local funs = {
['>'] = 'ptr = ptr + 1; ',
['<'] = 'ptr = ptr - 1; ',
['+'] = 'mem[ptr] = mem[ptr] + 1; ',
['-'] = 'mem[ptr] = mem[ptr] - 1; ',
['['] = 'while mem[ptr] ~= 0 do ',
[']'] = 'end; ',
['.'] = 'io.write(string.char(mem[ptr])); ',
[','] = 'mem[ptr] = (io.read(1) or "\\0"):byte(); ',
}

local prog = [[
  local mem = setmetatable({}, { __index = function() return 0 end})
  local ptr = 1
]]

local source = io.read('*all')

for p = 1, #source do
  local snippet = funs[source:sub(p,p)]
  if snippet then prog = prog .. snippet end
end

load(prog)()
