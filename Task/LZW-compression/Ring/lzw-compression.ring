# Project : LZW compression

plaintext = "TOBEORNOTTOBEORTOBEORNOT"
result = []
encode = encodelzw(plaintext)
for i = 1 to len(encode) step 2
    add(result,ascii(substr(encode,i,1)) + 256*ascii(substr(encode,i+1,1)))
next
showarray(result)
see decodelzw(encode)

func encodelzw(text)
       o = ""
       dict = list(4096)
       for i = 1 to 255
            dict[i] = char(i)
       next
       l = i
       i = 1
       w = left(text,1)
       while i < len(text)
              d = 0
              while d < l
                      c = d
                      if i > len(text)
                         exit
                      ok
                      for d = 1 to l
                           if w = dict[d]
                             exit
                           ok
                      next
                      if d < l
                         i = i + 1
                         w = w + substr(text,i,1)
                      ok
              end
              dict[l] = w
              l = l + 1
              w = right(w,1)
              o = o + char(c % 256) + char(floor(c / 256))
       end
       return o

func decodelzw(text)
       o = ""
       dict = list(4096)
       for i = 1 to 255
            dict[i] = char(i)
       next
       l = i
       c = ascii(left(text,1)) + 256*ascii(substr(text,2,1))
       w = dict[c]
       o = w
       if len(text) < 4
          return o
       ok
       for i = 3 to len(text) step 2
            c = ascii(substr(text,i,1)) + 256*ascii(substr(text,i+1,1))
            if c < l
               t = dict[c]
            else
               t = w + left(w,1)
            ok
            o = o + t
            dict[l] = w + left(t,1)
            l = l + 1
            w = t
       next
       return o

func showarray(vect)
        svect = ""
        for n = 1 to len(vect)
              svect = svect + vect[n] + " "
        next
        svect = left(svect, len(svect) - 1)
        see svect + nl
