# Project : Maximum triangle path sum

load "stdlib.ring"
ln = list(19)
ln[1] = "                   55"
ln[2] = "                  94 48"
ln[3] = "                95 30 96"
ln[4] = "               77 71 26 67"
ln[5] = "              97 13 76 38 45"
ln[6] = "             07 36 79 16 37 68"
ln[7] = "            48 07 09 18 70 26 06"
ln[8] = "           18 72 79 46 59 79 29 90"
ln[9] = "          20 76 87 11 32 07 07 49 18"
ln[10] = "         27 83 58 35 71 11 25 57 29 85"
ln[11] = "        14 64 36 96 27 11 58 56 92 18 55"
ln[12] = "       02 90 03 60 48 49 41 46 33 36 47 23"
ln[13] = "      92 50 48 02 36 59 42 79 72 20 82 77 42"
ln[14] = "     56 78 38 80 39 75 02 71 66 66 01 03 55 72"
ln[15] = "    44 25 67 84 71 67 11 61 40 57 58 89 40 56 36"
ln[16] = "   85 32 25 85 57 48 84 35 47 62 17 01 01 99 89 52"
ln[17] = "  06 71 28 75 94 48 37 10 23 51 06 48 53 18 74 98 15"
ln[18] = " 27 02 92 23 08 71 76 84 15 52 92 63 81 10 44 10 69 93"
ln[19] = "end"

matrix = newlist(20,20)
x = 1
size = 0

for n = 1 to len(ln) - 1
     ln2 = ln[n]
     ln2 = trim(ln2)
     for y = 1 to x
          matrix[x][y] = number(left(ln2,2))
          if len(ln2) > 4
              ln2 = substr(ln2,4,len(ln2)-4)
          ok
     next
     x = x + 1
     size = size + 1
next

for x = size - 1 to 1 step - 1
     for y = 1 to x
          s1 = matrix[x+1][y]
          s2 = matrix[x+1][y+1]
          if s1 > s2
             matrix[x][y] = matrix[x][y] + s1
          else
             matrix[x][y] = matrix[x][y] + s2
          ok
     next
next

see "maximum triangle path sum = " + matrix[1][1]
