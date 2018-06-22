# Project : IBAN
# Date    : 2018/01/03
# Author : Gal Zsolt (~ CalmoSoft ~)
# Email   : <calmosoft@gmail.com>

codes = list(5)
codes[1] = "GB82 WEST 1234 5698 7654 32"
codes[2] = "GB82 TEST 1234 5698 7654 32"
codes[3] = "GB81 WEST 1234 5698 7654 32"
codes[4] = "SA03 8000 0000 6080 1016 7519"
codes[5] = "CH93 0076 2011 6238 5295 7"

for y = 1 to len(codes)
      see codes[y]
      flag = 1
      codes[y] = substr(codes[y], " ", "")
      checkcode(codes[y])
      check = checkiban(codes[y])
      if check = 1
         see " is valid" + nl
      else
         see " is invalid" + nl
      ok
next

func checkcode(code)
        for n = 1 to 2
              if ascii(code[n]) < 65 or ascii(code[n]) > 90
                 flag = 0
              ok
        next
        for m = 3 to len(code)
              if (ascii(code[m]) > 64 and ascii(code[m]) < 91) or (ascii(code[m]) > 47 and ascii(code[m]) < 58)
              else
                  flag = 0
              ok
        next

func checkiban(code)
        code= substr(code, 5, len(code) - 4) + left(code, 4)
        for x = 1 to len(code)
              if ascii(code[x]) > 64 and ascii(code[x]) < 91
                 code = left(code, x-1) + string(ascii(code[x]) - 55) + right(code, len(code) - x)
              ok
        next
        modold = left(code,9) % 97
        for p = 1 to floor((len(code)-9)/7)
              modnew = string(modold) + substr(code, 10 + (p-1) * 7, 7)
              modnew = number(modnew) % 97
              modold = modnew
        next
        modrest = right(code, len(code) - ((p-1)*7 + 9))
        modnew = string(modold) + modrest
        modnew = number(modnew) % 97
        return modnew
