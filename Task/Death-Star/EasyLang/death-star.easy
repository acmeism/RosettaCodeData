func vdot a[] b[] .
   for i to len a[] : r += a[i] * b[i]
   return r
.
proc normalize &v[] .
   d = vdot v[] v[]
   invl = 1 / sqrt d
   for i to 3 : v[i] *= invl
.
func testhit &s[] x y &z1 &z2 .
   x -= s[1]
   y -= s[2]
   zsq = s[4] * s[4] - (x * x + y * y)
   if zsq >= 0
      zsqrt = sqrt zsq
      z1 = s[3] - zsqrt
      z2 = s[3] + zsqrt
      return 1
   .
.
proc death_star &pos[] &neg[] k amb dir[] .
   len vec[] 3
   for y = pos[2] - pos[4] to pos[2] + pos[4]
      for x = pos[1] - pos[4] to pos[1] + pos[4]
         if testhit pos[] x y zb1 zb2 = 1
            draw = 1
            hit = testhit neg[] x y zs1 zs2
            if hit = 1
               if zs1 > zb1
                  hit = 0
               elif zs2 > zb2
                  draw = 0
               .
            .
            if draw = 1
               if hit = 1
                  vec[1] = neg[1] - x
                  vec[2] = neg[2] - y
                  vec[3] = neg[3] - zs2
               else
                  vec[1] = x - neg[1]
                  vec[2] = y - neg[2]
                  vec[3] = zb1 - neg[3]
               .
               normalize vec[]
               s = vdot dir[] vec[]
               if s < 0 : s = 0
               lum = 100 * (pow s k + amb) / (1 + amb)
               gcolor3 lum lum lum
               grect 50 + x / 4, 50 + y / 4, 0.25 0.24
            .
         .
      .
   .
.
gbackground 000
gclear
dir[] = [ 20 40 -10 ]
normalize dir[]
pos[] = [ 0 0 0 120 ]
neg[] = [ -90 90 -30 100 ]
death_star pos[] neg[] 1.5 0.2 dir[]
