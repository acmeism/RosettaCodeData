-- Return whether the given string is a single ASCII character.
function is_ascii (str)
  return string.match(str, "[\0-\x7F]")
end

-- Return whether the given string is an initial byte in a multibyte sequence.
function is_init (str)
    return string.match(str, "[\xC2-\xF4]")
end

-- Return whether the given string is a continuation byte in a multibyte sequence.
function is_cont (str)
    return string.match(str, "[\x80-\xBF]")
end

-- Accept a filestream.
-- Return the next UTF8 character in the file.
function read_char (file)
    local multibyte -- build a valid multibyte Unicode character

    for c in file:lines(1) do
        if is_ascii(c) then
            if multibyte then
                -- We've finished reading a Unicode character; unread the next byte,
                -- and return the Unicode character.
                file:seek("cur", -1)
                return multibyte
            else
                return c
            end
        elseif is_init(c) then
            if multibyte then
                file:seek("cur", -1)
                return multibyte
            else
                multibyte = c
            end
        elseif is_cont(c) then
            multibyte = multibyte .. c
        else
            assert(false)
        end
    end
end

-- Test.
function read_all ()
    testfile = io.open("tmp.txt", "w")
    testfile:write("𝄞AöЖ€𝄞Ελληνικάyä®€成长汉\n")
    testfile:close()
    testfile = io.open("tmp.txt", "r")

    while true do
        local c = read_char(testfile)
        if not c then return else io.write(" ", c) end
    end
end
