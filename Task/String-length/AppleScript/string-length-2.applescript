set inString to "Hello World" as Unicode text
set byteCount to 0
set idList to id of inString

repeat with incr in idList
  set byteCount to byteCount + 2
  if incr as integer > 65535 then
    set byteCount to byteCount + 2
  end if
end repeat

byteCount
