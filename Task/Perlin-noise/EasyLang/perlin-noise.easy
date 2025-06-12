p[] = [ 151 160 137 91 90 15 131 13 201 95 96 53 194 233 7 225 140 36 103 30 69 142 8 99 37 240 21 10 23 190 6 148 247 120 234 75 0 26 197 62 94 252 219 203 117 35 11 32 57 177 33 88 237 149 56 87 174 20 125 136 171 168 68 175 74 165 71 134 139 48 27 166 77 146 158 231 83 111 229 122 60 211 133 230 220 105 92 41 55 46 245 40 244 102 143 54 65 25 63 161 1 216 80 73 209 76 132 187 208 89 18 169 200 196 135 130 116 188 159 86 164 100 109 198 173 186 3 64 52 217 226 250 124 123 5 202 38 147 118 126 255 82 85 212 207 206 59 227 47 16 58 17 182 189 28 42 223 183 170 213 119 248 152 2 44 154 163 70 221 153 101 155 167 43 172 9 129 22 39 253 19 98 108 110 79 113 224 232 178 185 112 104 218 246 97 228 251 34 242 193 238 210 144 12 191 179 162 241 81 51 145 235 249 14 239 107 49 192 214 31 181 199 106 157 184 84 204 176 115 121 50 45 127 4 150 254 138 236 205 93 222 114 67 29 24 72 243 141 128 195 78 66 215 61 156 180 ]
for i to 256 : p[] &= p[i]
#
func fade t .
   return t * t * t * (t * (t * 6 - 15) + 10)
.
func lerp t a b .
   return a + t * (b - a)
.
func grad hash x y z .
   h = hash mod 16
   if h = 0 or h = 12
      return x + y
   elif h = 1 or h = 14
      return y - x
   elif h = 2
      return x - y
   elif h = 3
      return -x - y
   elif h = 4
      return x + z
   elif h = 5
      return z - x
   elif h = 6
      return x - z
   elif h = 7
      return -x - z
   elif h = 8
      return y + z
   elif h = 9 or h = 13
      return z - y
   elif h = 10
      return y - z
   .
   return -y - z
.
func noise x y z .
   a = floor x mod 256
   b = floor y mod 256
   c = floor z mod 256
   xx = x mod 1
   yy = y mod 1
   zz = z mod 1
   u = fade xx
   v = fade yy
   w = fade zz
   a0 = p[a + 1] + b
   a1 = p[a0 + 1] + c
   a2 = p[a0 + 2] + c
   b0 = p[a + 2] + b
   b1 = p[b0 + 1] + c
   b2 = p[b0 + 2] + c
   k1 = grad p[a1 + 1] xx yy zz
   k2 = grad p[b1 + 1] (xx - 1) yy zz
   k3 = grad p[a2 + 1] xx (yy - 1) zz
   k4 = grad p[b2 + 1] (xx - 1) (yy - 1) zz
   k5 = grad p[a1 + 2] xx yy (zz - 1)
   k6 = grad p[b1 + 2] (xx - 1) yy (zz - 1)
   k7 = grad p[a2 + 2] xx (yy - 1) (zz - 1)
   k8 = grad p[b2 + 2] (xx - 1) (yy - 1) (zz - 1)
   return lerp w (lerp v (lerp u k1 k2) (lerp u k3 k4)) (lerp v (lerp u k5 k6) (lerp u k7 k8))
.
numfmt 0 17
print noise 3.14 42 7
#
# demo
for y = 0 to 199
   for x = 0 to 199
      p = noise (x / 30) (y / 30) 0.1
      gcolor3 p p p
      grect x / 2 y / 2 0.6 0.6
   .
.
