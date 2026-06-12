@enum streamstate GET_FF GET_LF GET_TAB GET_CHAR ABORT
chars = Dict(GET_FF => ['\f'], GET_LF => ['\n'], GET_TAB => ['\t'])

function stream_decode_jit(iostream)
    msg, state, ffcount, lfcount, tabcount, charcount = "", GET_FF, 0, 0, 0, 0
    while true
        if state == ABORT || eof(iostream)
            return msg
        end
        ch = read(iostream, Char)
        if state == GET_FF && ch in chars[GET_FF]
            ffcount += 1
            state = GET_LF
            lfcount = 0
        elseif state == GET_LF && ch in chars[GET_LF]
            if (lfcount += 1) == ffcount
                state = GET_TAB
                tabcount = 0
            end
        elseif state == GET_TAB && ch in chars[GET_TAB]
            if (tabcount += 1) == ffcount
                state = GET_CHAR
                charcount = 0
            end
        elseif state == GET_CHAR
            if (charcount += 1) == ffcount
                print(ch)
                msg *= ch
                if ch == '!'
                    state = ABORT
                else
                    state = GET_FF
                end
            end
        end
    end
end

stream_decode_jit(open("filename.txt", "r"))
