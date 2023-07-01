# Project  Jewels and Stones

jewels = "aA"
stones = "aAAbbbb"
see jewelsandstones(jewels,stones) + nl
jewels = "z"
stones = "ZZ"
see jewelsandstones(jewels,stones) + nl

func jewelsandstones(jewels,stones)
        num = 0
        for n = 1 to len(stones)
             pos = substr(jewels,stones[n])
             if pos > 0
                num = num + 1
             ok
        next
        return num
