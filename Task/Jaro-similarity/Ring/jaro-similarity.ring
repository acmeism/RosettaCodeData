# Project : Jaro distance

decimals(12)

see " jaro (MARTHA, MARHTA)  = " +  jaro("MARTHA", "MARHTA") + nl
see " jaro (DIXON, DICKSONX) = " + jaro("DIXON", "DICKSONX") + nl
see " jaro (JELLYFISH, SMELLYFISH) = " + jaro("JELLYFISH", "SMELLYFISH") + nl

func jaro(word1, word2)
        if len(word1) > len(word2)
            swap(word1, word2)
        ok
        j = 1
        t = 0
        m = 0
        s1 = len(word1)
        s2 = len(word2)
        maxdist = (s2 / 2) -1
        for i = 1 to s1
             if word1[i] = word2[j] and j < max(len(word2), len(word2)) + 1
                m = m +1
                word2[j] = char(32)
             else
                for j1 = max(1, i - maxdist) to min(s2 -1, i + maxdist)
                     if word1[i] = word2[j1]
                        t = t +1
                        m = m +1
                        word2[j1] = char(32)
                        if j1 > j and j1 < max(len(word2), len(word2)) + 1
                           j = j1
                        ok
                    ok
                next
             ok
             if j < max(len(word2), len(word2))
                j = j + 1
             ok
        next
        if m = 0
           return 0
        ok
        t = floor(t / 2)
        return (m / s1 + m / s2 + ((m - t) / m)) / 3

func swap(a, b)
        temp = a
        a = b
        b = temp
        return [a, b]
