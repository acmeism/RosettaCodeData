sysconf topleft
len hxc[][] 26
len ltr$[] 26
global chosenltrs$ .
proc shuffle .
   for i = 1 to 26 : ltr$[i] = strchar (i + 64)
   for i = 26 downto 2
      swap ltr$[i] ltr$[random i]
   .
.
proc drawhexa cx cy r c .
   gpenup
   gcolor c
   for ang = 0 step 60 to 360
      x = cx + r * cos ang
      y = cy + r * sin ang
      glineto x y
   .
.
proc fillhexa cx cy r c .
   gpenup
   gcolor c
   for ang = 0 step 60 to 300
      x = cx + r * cos ang
      y = cy + r * sin ang
      a[] &= x
      a[] &= y
   .
   gpolygon a[]
.
proc cell cx cy fc bc tc lt$ .
   fillhexa cx cy 10 bc
   drawhexa cx cy 10 fc
   gcolor tc
   gtextsize 8
   gtext cx - 3 cy - 3 lt$
.
proc grid ox oy fc bc tc .
   cx = ox
   cy = oy
   for i = 1 to 5
      cy = oy + 15
      if i mod 2 = 1 : cy -= 8.5
      for j = 1 to 4
         cnt += 1
         cell cx cy fc bc tc ltr$[cnt]
         hxc[cnt][] = [ cx cy 0 ]
         cy += 17
      .
      cx += 15
   .
.
proc init .
   chosenltrs$ = ""
   gbackground 000
   gclear
   shuffle
   grid 18 7 333 973 000
.
func pnc ax ay bx by .
   return if (bx - ax) * (bx - ax) + (by - ay) * (by - ay) <= 81
.
proc showltr key$ .
   chosenltrs$ &= key$
   gcolor 888
   gtextsize 7
   gtext 7 89 chosenltrs$
.
proc actcell i .
   hxc[i][3] = 1
   cell hxc[i][1] hxc[i][2] 333 305 888 ltr$[i]
   showltr ltr$[i]
.
on mouse_down
   if len chosenltrs$ = 20
      init
      return
   .
   for i to 20
      if pnc mouse_x mouse_y hxc[i][1] hxc[i][2] = 1 and hxc[i][3] = 0
         actcell i
         break 1
      .
   .
.
on key_down
   if len chosenltrs$ = 20
      init
      return
   .
   c = strcode keybkey
   if c >= 97 and c <= 122 : c -= 32
   k$ = strchar c
   for i = 1 to 20
      if ltr$[i] = k$ and hxc[i][3] = 0
         actcell i
         break 1
      .
   .
.
init
