local repl = {
 ['>'] = 'ptr = ptr + 1',
 ['<'] = 'ptr = ptr - 1',
 ['+'] = 'mem[ptr] = mem[ptr] + 1',
 ['-'] = 'mem[ptr] = mem[ptr] - 1',
 ['['] = 'while mem[ptr] ~= 0 do',
 [']'] = 'end',
 ['.'] = 'io.write(string.char(mem[ptr]))',
 [','] = 'mem[ptr] = (io.read(1) or "\\0"):byte()',
}

local prog = {[[
  local mem = setmetatable({}, { __index = function() return 0 end})
  local ptr = 1
]]}

local source, i = io.read('*all'), 1
for char in source:gmatch"[<>+.,%[%]%-]" do
  i, prog[i] = i+1, repl[char]
end

load( table.concat(prog, " ") )()
