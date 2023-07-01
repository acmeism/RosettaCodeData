local find, format = string.find, string.format
local function printf(fmt, ...) print(format(fmt,...)) end

local pattern = '(.).-%1' -- '(.)' .. '.-' .. '%1'

function report_dup_char(subject)
    local pos1, pos2, char = find(subject, pattern)

    local prefix = format('"%s" (%d)', subject, #subject)
    if pos1 then
        local byte = char:byte()
        printf("%s: '%s' (0x%02x) duplicates at %d, %d", prefix, char, byte, pos1, pos2)
    else
        printf("%s: no duplicates", prefix)
    end
end

local show = report_dup_char
show('coccyx')
show('')
show('.')
show('abcABC')
show('XYZ ZYX')
show('1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ')
