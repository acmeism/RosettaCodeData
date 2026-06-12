proc tobern2 a0 a1 a2 &b0 &b1 &b2 .
   b0 = a0
   b1 = a0 + a1 / 2
   b2 = a0 + a1 + a2
.
func evalbern2 b0 b1 b2 t .
   s = 1.0 - t
   b01 = s * b0 + t * b1
   b12 = s * b1 + t * b2
   return s * b01 + t * b12
.
proc tobern3 a0 a1 a2 a3 &b0 &b1 &b2 &b3 .
   b0 = a0
   b1 = a0 + a1 / 3
   b2 = a0 + a1 * 2 / 3 + a2 / 3
   b3 = a0 + a1 + a2 + a3
.
func evalbern3 b0 b1 b2 b3 t .
   s = 1 - t
   b01 = s * b0 + t * b1
   b12 = s * b1 + t * b2
   b23 = s * b2 + t * b3
   b012 = s * b01 + t * b12
   b123 = s * b12 + t * b23
   return s * b012 + t * b123
.
proc bern2to3 q0 q1 q2 &c0 &c1 &c2 &c3 .
   c0 = q0
   c1 = q0 / 3 + q1 * 2 / 3
   c2 = q1 * 2 / 3 + q2 / 3
   c3 = q2
.
func evalmono2 a0 a1 a2 t .
   return a0 + (t * (a1 + (t * a2)))
.
func evalmono3 a0 a1 a2 a3 t .
   return a0 + (t * (a1 + (t * (a2 + (t * a3)))))
.
#
proc subprogr1 m0 m1 m2 .
   tobern2 m0 m1 m2 b0 b1 b2
   write "mono {" & m0 & " " & m1 & " " & m2 & "}"
   print "--> bern {" & b0 & " " & b1 & " " & b2 & "}"
.
print "Subprogram(1) examples:"
subprogr1 1 0 0
subprogr1 1 2 3
print ""
#
proc subprogr2 s$ x b0 b1 b2 .
   y = evalbern2 b0 b1 b2 x
   print s$ & "(" & x & ") = " & y
.
print "Subprogram(2) examples:"
subprogr2 "p" 0.25 1 0 0
subprogr2 "p" 7.5 1 0 0
subprogr2 "q" 0.25 1 2 3
subprogr2 "q" 7.5 1 2 3
print ""
#
proc subprogr3 m0 m1 m2 m3 .
   tobern3 m0 m1 m2 m3 b0 b1 b2 b3
   write "mono {" & m0 & " " & m1 & " " & m2 & " " & m3 & "}"
   print "--> bern {" & b0 & " " & b1 & " " & b2 & " " & b3 & "}"
.
print "Subprogram(3) examples:"
subprogr3 1 0 0 0
subprogr3 1 2 3 0
subprogr3 1 2 3 4
print ""
#
proc subprogr4 s$ x b0 b1 b2 b3 .
   y = evalbern3 b0 b1 b2 b3 x
   print s$ & "(" & x & ") = " & y
.
print "Subprogram(4) examples:"
subprogr4 "p" 0.25 1 0 0 0
subprogr4 "p" 7.5 1 0 0 0
subprogr4 "q" 0.25 1 2 3 0
subprogr4 "q" 7.5 1 2 3 0
subprogr4 "r" 0.25 1 2 3 4
subprogr4 "r" 7.5 1 2 3 4
print ""
#
proc subprogr5 m0 m1 m2 .
   tobern2 m0 m1 m2 b0 b1 b2
   bern2to3 b0 b1 b2 c0 c1 c2 c3
   write "mono {" & b0 & " " & b1 & " " & b2 & "}"
   print "--> bern {" & c0 & " " & c1 & " " & c2 & " " & c3 & "}"
.
print "Subprogram(5) examples:"
subprogr5 1 0 0
subprogr5 1 2 3
