# Project : Gray code

pos = 5
see "0 : 00000 => 00000 => 00000" + nl
for n = 1 to 31
     res1 = tobase(n, 2, pos)
     res2 = tobase(grayencode(n), 2, pos)
     res3 = tobase(graydecode(n), 2, pos)
     see "" + n + " : " + res1 + " => " + res2 +  " => " + res3 + nl
next

func grayencode(n)
        return n ^ (n >> 1)

func graydecode(n)
        p = n
        while (n = n >> 1)
                  p = p ^ n
        end
        return p

func tobase(nr, base, pos)
        binary = 0
        i = 1
       while(nr != 0)
              remainder = nr % base
              nr = floor(nr/base)
              binary= binary + (remainder*i)
              i = i*10
       end
       result = ""
       for nr = 1 to  pos - len(string(binary))
             result = result + "0"
       next
       result = result + string(binary)
       return result
