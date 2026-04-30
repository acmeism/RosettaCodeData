global W H img[][] .
dx[] = [ 0 1 1 1 0 -1 -1 -1 0 ]
dy[] = [ -1 -1 0 1 1 1 0 -1 -1 ]
#
func A x y .
   cur = img[y + dy[1]][x + dx[1]]
   for i = 2 to 9
      nxt = img[y + dy[i]][x + dx[i]]
      if cur = 0 and nxt = 1 : c += 1
      cur = nxt
   .
   return c
.
func B x y .
   for i = 2 to 9
      c += img[y + dy[i]][x + dx[i]]
   .
   return c
.
func commonStep x y .
   if img[y][x] <> 1 or x <= 1 or x >= W or y <= 1 or y >= H : return 0
   b = B x y
   if b < 2 or b > 6 : return 0
   a = A x y
   if a <> 1 : return 0
   return 1
.
func stepOne x y .
   if commonStep x y = 0 : return 0
   p2 = img[y + dy[1]][x + dx[1]]
   p4 = img[y + dy[3]][x + dx[3]]
   p6 = img[y + dy[5]][x + dx[5]]
   p8 = img[y + dy[7]][x + dx[7]]
   if p4 = 0 or p6 = 0 or p2 + p8 = 0 : return 1
   return 0
.
func stepTwo x y .
   if commonStep x y = 0 : return 0
   p2 = img[y + dy[1]][x + dx[1]]
   p4 = img[y + dy[3]][x + dx[3]]
   p6 = img[y + dy[5]][x + dx[5]]
   p8 = img[y + dy[7]][x + dx[7]]
   if p2 = 0 or p8 = 0 or p4 + p6 = 0 : return 1
   return 0
.
func doStepOneAll .
   len del[][] H
   for y = 1 to H : len del[y][] W
   for y = 2 to H - 1 : for x = 2 to W - 1
      if stepOne x y = 1
         del[y][x] = 1
         cnt += 1
      .
   .
   if cnt > 0
      for y = 2 to H - 1 : for x = 2 to W - 1
         if del[y][x] = 1 : img[y][x] = 0
      .
      return 1
   .
   return 0
.
func doStepTwoAll .
   len del[][] H
   for y = 1 to H : len del[y][] W
   for y = 2 to H - 1 : for x = 2 to W - 1
      if stepTwo x y = 1
         del[y][x] = 1
         cnt += 1
      .
   .
   if cnt > 0
      for y = 2 to H - 1 : for x = 2 to W - 1
         if del[y][x] = 1 : img[y][x] = 0
      .
      return 1
   .
   return 0
.
proc zhangSuenThin .
   repeat
      changed = 0
      if doStepOneAll = 1 : changed = 1
      if doStepTwoAll = 1 : changed = 1
      until changed = 0
   .
.
proc readAscii .
   W = 0
   repeat
      s$ = input
      until s$ = ""
      lines$[] &= s$
      if len s$ > W : W = len s$
   .
   H = len lines$[]
   len img[][] H
   for y = 1 to H
      len img[y][] W
      c$[] = strchars lines$[y]
      for x = 1 to len c$[]
         h = strpos " #" c$[x]
         img[y][x] = h - 1
      .
   .
.
proc printAscii .
   for y = 1 to H
      for x = 1 to W
         write substr " #" (img[y][x] + 1) 1
      .
      print ""
   .
.
readAscii
zhangSuenThin
printAscii
#
#
input_data
 #################                   #############
 ##################               ################
 ###################            ##################
 ########     #######          ###################
   ######     #######         #######       ######
   ######     #######        #######
   #################         #######
   ################          #######
   #################         #######
   ######     #######        #######
   ######     #######        #######
   ######     #######         #######       ######
 ########     #######          ###################
 ########     ####### ######    ################## ######
 ########     ####### ######      ################ ######
 ########     ####### ######         ############# ######
