set inString to "Hello é̦世界"
set byteCount to 0

repeat with c in inString
	set t to id of c
	if ((count of t) > 0) then
		repeat with i in t
			set byteCount to byteCount + doit(i)
		end repeat
	else
		set byteCount to byteCount + doit(t)
	end if
end repeat

byteCount

on doit(cid)
	set n to (cid as integer)
	if n > 67108863 then -- 0x3FFFFFF
		return 6
	else if n > 2097151 then -- 0x1FFFFF
		return 5
	else if n > 65535 then -- 0xFFFF
		return 4
	else if n > 2047 then -- 0x07FF
		return 3
	else if n > 127 then -- 0x7F
		return 2
	else
		return 1
	end if
end doit
