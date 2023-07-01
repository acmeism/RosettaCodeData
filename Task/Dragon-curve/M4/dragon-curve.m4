# The macros which return a pair of values x,y expand to an unquoted 123,456
# which is suitable as arguments to a further macro.  The quoting is slack
# because the values are always integers and so won't suffer unwanted macro
# expansion.

#                0,1                 Vertex and segment x,y numbering.
#                 |
#                 |                  Segments are numbered as if a
#                 |s=0,1             square grid turned anti-clockwise
#                 |                  by 45 degrees.
#                 |
#  -1,0 -------- 0,0 -------- 1,0    vertex_to_seg_east(x,y) returns
#        s=-1,1   |   s=0,0          the segment x,y to the East,
#                 |                  so vertex_to_seg_east(0,0) is 0,0
#                 |
#                 |s=-1,0            vertex_to_seg_west(x,y) returns
#                 |                  the segment x,y to the West,
#                0,-1                so vertex_to_seg_west(0,0) is -1,1
#
define(`vertex_to_seg_east',  `eval($1 + $2),     eval($2 - $1)')
define(`vertex_to_seg_west',  `eval($1 + $2 - 1), eval($2 - $1 + 1)')
define(`vertex_to_seg_south', `eval($1 + $2 - 1), eval($2 - $1)')

# Some past BSD m4 didn't have "&" operator, so mod2(n) using % instead.
# mod2() returns 0,1 even if "%" gives -1 for negative odds.
#
define(`mod2', `ifelse(eval($1 % 2),0,0,1)')

# seg_to_even(x,y) returns x,y moved to an "even" position by subtracting an
# offset in a way which suits the segment predicate test.
#
# seg_offset_y(x,y) is a repeating pattern
#
#    | 1,1,0,0
#    | 1,1,0,0
#    | 0,0,1,1
#    | 0,0,1,1
#    +---------
#
# seg_offset_x(x,y) is the same but offset by 1 in x,y
#
#    | 0,1,1,0
#    | 1,0,0,1
#    | 1,0,0,1
#    | 0,1,1,0
#    +---------
#
# Incidentally these offset values also give n which is the segment number
# along the curve.  "x_offset XOR y_offset" is 0,1 and is a bit of n from
# low to high.
#
define(`seg_offset_y', `mod2(eval(($1 >> 1) + ($2 >> 1)))')
define(`seg_offset_x', `seg_offset_y(eval($1+1), eval($2+1))')
define(`seg_to_even', `eval($1 - seg_offset_x($1,$2)),
                       eval($2 - seg_offset_y($1,$2))');

# xy_div_iplus1(x,y) returns x,y divided by complex number i+1.
# So (x+i*y)/(i+1) which means newx = (x+y)/2, newy = (y-x)/2.
# Must have x,y "even", meaning x+y even, so newx and newy are integers.
#
define(`xy_div_iplus1', `eval(($1 + $2)/2), eval(($2 - $1)/2)')

# seg_is_final(x,y) returns 1 if x,y is one of the final four points.
# On these four points xy_div_iplus1(seg_to_even(x,y)) returns x,y
# unchanged, so the seg_pred() recursion does not reduce any further.
#
#       ..   |  ..
#      final | final      y=+1
#      final | final      y=0
#     -------+--------
#       ..   |  ..
#       x=-1    x=0
#
define(`seg_is_final', `eval(($1==-1 || $1==0) && ($2==1 || $2==0))')

# seg_pred(x,y) returns 1 if segment x,y is on the dragon curve.
# If the final point reached is 0,0 then the original x,y was on the curve.
# (If a different final point then x,y was one of four rotated copies of the
# curve.)
#
define(`seg_pred', `ifelse(seg_is_final($1,$2), 1,
                           `eval($1==0 && $2==0)',
                           `seg_pred(xy_div_iplus1(seg_to_even($1,$2)))')')

# vertex_pred(x,y) returns 1 if point x,y is on the dragon curve.
# The curve always turns left or right at a vertex, it never crosses itself,
# so if a vertex is visited then either the segment to the east or to the
# west must have been traversed.  Prefer ifelse() for the two checks since
# eval() || operator is not a short-circuit.
#
define(`vertex_pred', `ifelse(seg_pred(vertex_to_seg_east($1,$2)),1,1,
                             `seg_pred(vertex_to_seg_west($1,$2))')')

# forloop(varname, start,end, body)
# Expand body with varname successively define()ed to integers "start" to
# "end" inclusive.  "start" to "end" can go either increasing or decreasing.
#
define(`forloop', `define(`$1',$2)$4`'dnl
ifelse($2,$3,,`forloop(`$1',eval($2 + 2*($2 < $3) - 1), $3, `$4')')')

#----------------------------------------------------------------------------

# dragon01(xmin,xmax, ymin,ymax) prints an array of 0s and 1s which are the
# vertex_pred() values.  `y' runs from ymax down to ymin so that y
# coordinate increases up the screen.
#
define(`dragon01',
`forloop(`y',$4,$3, `forloop(`x',$1,$2, `vertex_pred(x,y)')
')')

# dragon_ascii(xmin,xmax, ymin,ymax) prints an ascii art dragon curve.
# Each y value results in two output lines.  The first has "+" vertices and
# "--" horizontals.  The second has "|" verticals.
#
define(`dragon_ascii',
`forloop(`y',$4,$3,
`forloop(`x',$1,$2,
`ifelse(vertex_pred(x,y),1, `+', ` ')dnl
ifelse(seg_pred(vertex_to_seg_east(x,y)), 1, `--', `  ')')
forloop(`x',$1,$2,
`ifelse(seg_pred(vertex_to_seg_south(x,y)), 1, `|  ', `   ')')
')')

#--------------------------------------------------------------------------
divert`'dnl

# 0s and 1s directly from vertex_pred().
#
dragon01(-7,23,      dnl X range
         -11,10)     dnl Y range

# ASCII art lines.
#
dragon_ascii(-6,5,      dnl X range
             -10,2)     dnl Y range
