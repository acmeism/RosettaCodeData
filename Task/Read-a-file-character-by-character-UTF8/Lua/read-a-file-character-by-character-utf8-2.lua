function read_rune (T)
  local R
  if io.type(T.file)~="closed file" then
    for c in T.file:lines(1) do
      T.buffer = (T.buffer or "") .. c
      if utf8.len(T.buffer)==1 then
        T.buffer, R = nil, T.buffer
        return R
      end
    end
  end
  R, T.buffer = T.buffer, nil
  return R
end

local file = io.tmpfile()
file:write("𝄞AöЖ€𝄞Ελληνικάyä®€成长汉\n")
file:seek"set"

for rune in read_rune, {file=file} do
  io.write(rune, " ")
end
