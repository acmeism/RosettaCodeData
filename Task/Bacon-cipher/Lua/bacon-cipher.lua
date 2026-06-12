function Bacon( txt, secret, e )
    local alpha = {}
    function encode( txt, secret )
        function toAlpha( secret )
            local str, z = "", 0
            secret = secret:upper()
            for i = 1, string.len( secret ) do
                z = secret:sub( i, i )
                if z < 'A' or z > 'Z'  then
                    str = str .. alpha[27]
                else
                    k = z:byte( 1 ) - 65 + 1
                    str = str .. alpha[k]
                end
            end
            return str
        end

        local sec, encoded, idx = toAlpha( secret ), "", 0
        if sec:len() > txt:len() then
            print( "Text is too short!" )
           return
        end

        txt = txt:lower()
        for i = 1, string.len( sec ) do
            t = txt:sub( idx, idx )
            while( t < 'a' or t > 'z' ) do
                encoded = encoded .. t
                idx = idx + 1
                t = txt:sub( idx, idx )
            end

            idx = idx + 1
            if sec:sub( i, i ) == '1' then
                encoded = encoded .. string.char( t:byte(1) - 32 )
            else
                encoded = encoded .. t
            end
        end
        return encoded
    end

    function decode( txt )
        local secret, c = "", 0
        for i = 1, string.len( txt ) do
            c = txt:sub( i, i )
            if not( c < 'a' and ( c < 'A' or c > 'Z' ) or c > 'z' ) then
                local s = 0
                if c == c:upper() then s = 1 end
                secret = secret .. s
            end
        end

        function fromAlpha( secret )
            function find( a, arr )
                for i = 1, #arr do
                    if arr[i] == a then return i end
                end
                return -1
            end

            local l, msg, c, idx = secret:len(), "", 0, 0
            if math.fmod( l, 5 ) ~= 0 then
                print( "Message length does not match!" )
                return
            end
            for i = 1, l, 5 do
                c = secret:sub( i, i + 4 )
                idx = find( c, alpha )
                if idx > 0 then
                    if idx == 27 then
                        msg = msg .. " "  -- unknown char - add space
                    else
                        msg = msg .. string.char( 64 + idx )
                    end
                end
            end
            return msg
        end
        return fromAlpha( secret )
    end

    -- create alphabet
    for i = 0, 26 do
        local t, num = "", i
        for b = 5, 1, -1 do
            t =  math.fmod( num, 2 ) .. t
            num = math.floor( num / 2 )
        end
        alpha[#alpha + 1] = t
    end

    -- encode or decode
    if e == 1 then
        return encode( txt, secret )
    elseif e == 0 then
        return decode( secret )
    end
end

local a = Bacon( "Chase the pig around the house present belly, scratch hand when stroked. "..
                 "When in doubt, wash jump around on couch, meow constantly until given food, "..
                 "favor packaging over toy. And sometimes switches in french and say 'miaou' "..
                 "just because well why not has closed eyes but still sees you lick yarn hanging "..
                 "out of own butt so pelt around the house and up and down stairs chasing phantoms.",
                 "Fall over dead, not really but gets sypathy", 1 )
print( a )
print( Bacon( "", a, 0 ) )
