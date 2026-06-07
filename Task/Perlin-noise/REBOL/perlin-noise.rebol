Rebol [
    title: "Rosetta code: Perlin noise"
    file:  %Perlin_noise.r3
    url:   https://rosettacode.org/wiki/Perlin_noise
]

perlin-noise: function/with [
    "Returns Perlin noise value in range [-1.0, 1.0] for the given 3D coordinate."
    x [number!] y [number!] z [number!]
][
    ;; Unit cube coords containing the point (0–255)
    xi: 255 and to integer! x
    yi: 255 and to integer! y
    zi: 255 and to integer! z

    ;; Fractional position within the unit cube
    xf: x - xi
    yf: y - yi
    zf: z - zi

    ;; Fade curves smooth the interpolation (6t^5 - 15t^4 + 10t^3)
    u: fade xf
    v: fade yf
    w: fade zf

    ;; Hash the 8 corners of the cube
    A:  yi + pickz p xi
    AA: zi + pickz p A
    AB: zi + pick  p A   ; A+1
    B:  yi + pick  p xi  ; xi+1
    BA: zi + pickz p B
    BB: zi + pick  p B   ; B+1

    ;; Pre-compute shifted fractions to avoid repetition
    xf-1: xf - 1
    yf-1: yf - 1
    zf-1: zf - 1

    ;; Trilinearly interpolate gradients from all 8 corners
    lerp
        (lerp                                  ; z=0 face
            (lerp                              ; z=0, y=0 edge
                grad pickz p AA xf   yf zf     ; corner 0,0,0
                grad pickz p BA xf-1 yf zf     ; corner 1,0,0
            u)
        (lerp                                  ; z=0, y=1 edge
            grad pickz p AB xf   yf-1 zf       ; corner 0,1,0
            grad pickz p BB xf-1 yf-1 zf       ; corner 1,1,0
            u)
        v)
    (lerp                                      ; z=1 face
        (lerp                                  ; z=1, y=0 edge
            grad pickz p AA + 1 xf   yf zf-1   ; corner 0,0,1
            grad pickz p BA + 1 xf-1 yf zf-1   ; corner 1,0,1
            u)
        (lerp                                  ; z=1, y=1 edge
            grad pickz p AB + 1 xf   yf-1 zf-1 ; corner 0,1,1
            grad pickz p BB + 1 xf-1 yf-1 zf-1 ; corner 1,1,1
            u)
        v)
    w
][
    ;; Ken Perlin's reference permutation table (256 values, doubled to 512
    ;; to avoid index wrapping when accessing p[i+1])
    p: #(u8! [
        151 160 137 91 90 15 131 13 201 95 96 53 194 233 7 225 140 36 103 30
        69 142 8 99 37 240 21 10 23 190 6 148 247 120 234 75 0 26 197 62 94
        252 219 203 117 35 11 32 57 177 33 88 237 149 56 87 174 20 125 136
        171 168 68 175 74 165 71 134 139 48 27 166 77 146 158 231 83 111 229
        122 60 211 133 230 220 105 92 41 55 46 245 40 244 102 143 54 65 25
        63 161 1 216 80 73 209 76 132 187 208 89 18 169 200 196 135 130 116
        188 159 86 164 100 109 198 173 186 3 64 52 217 226 250 124 123 5 202
        38 147 118 126 255 82 85 212 207 206 59 227 47 16 58 17 182 189 28
        42 223 183 170 213 119 248 152 2 44 154 163 70 221 153 101 155 167
        43 172 9 129 22 39 253 19 98 108 110 79 113 224 232 178 185 112 104
        218 246 97 228 251 34 242 193 238 210 144 12 191 179 162 241 81 51
        145 235 249 14 239 107 49 192 214 31 181 199 106 157 184 84 204 176
        115 121 50 45 127 4 150 254 138 236 205 93 222 114 67 29 24 72 243
        141 128 195 78 66 215 61 156 180
    ])
    append p p

    ;; Smoothstep: maps t to a smooth S-curve with zero derivative at 0 and 1
    fade: func [t [number!]] [
        t * t * t * (t * (t * 6 - 15) + 10)
    ]

    ;; Maps the low 4 bits of hash to one of 12 gradient directions
    grad: func [hash [integer!] x [number!] y [number!] z [number!]
        /local h u v
    ][
        h: hash and 15
        u: either h < 8 [x][y]
        v: case [
            h < 4          [y]
            find [12 14] h [x]
            'else          [z]
        ]
        (either zero? h and 1 [u] [negate u]) +
        (either zero? h and 2 [v] [negate v])
    ]
]

; --- Example usage ---
print perlin-noise 3.14 42 7
