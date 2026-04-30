-- Accept a filestream.
-- Return the next UTF8 character in the file.
function read_char (file)
    local multibyte -- build a valid multibyte Unicode character
    local is_ascii = "[\0-\x7F]" -- pattern for an ascii character
    local is_init = "[\xC2-\xF4]" -- pattern for an initial byte in a multibyte sequence
    local is_cont = "[\x80-\xBF]" -- pattern for a continuation byte in a multibyte sequence

    for c in file:lines(1) do
        if c:find(is_ascii) then
            if multibyte then
                -- We've finished reading a Unicode character; unread the next byte,
                -- and return the Unicode character.
                file:seek("cur", -1)
                return multibyte
            else
                return c
            end
        elseif c:find(is_init) then
            if multibyte then
                file:seek("cur", -1)
                return multibyte
            else
                multibyte = c
            end
        elseif c:find(is_cont) then
            multibyte = multibyte .. c
        else
            error()
        end
    end
end

-- Test.
function read_all ()
    testfile = io.tmpfile()
    testfile:write("𝄞AöЖ€𝄞Ελληνικάyä®€成长汉\n")
    testfile:seek"set"

    while true do
        local c = read_char(testfile)
        if not c then return else io.write(" ", c) end
    end
end
