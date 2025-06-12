function Tokenize(str, sep, esc) local R = {}
  local repl = sep~="\0" and esc~="\0" and "\0"
    or sep~="\1" and esc~="\1" and "\1"
    or sep~="\2" and esc~="\2" and "\2"
  local fakeStr = str:gsub("[%" .. esc .. "].", repl .. repl)
  local pattern = "()[^%" .. sep .. "]*()"
  for start, fin in fakeStr:gmatch(pattern) do
    R[#R+1] = str:sub(start, fin-1)
  end
  return R
end
