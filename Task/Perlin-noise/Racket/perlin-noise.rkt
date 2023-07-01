#lang racket
(define (floor-to-255 x)
  (bitwise-and (exact-floor x) #xFF))

(define (fade t)
  (* t t t (+ 10 (* t (- (* t 6) 15)))))

(define (lerp t a b)
  (+ a (* t (- b a))))

;; CONVERT LO 4 BITS OF HASH CODE INTO 12 GRADIENT DIRECTIONS.
(define (grad hsh x y z)
  (define h (bitwise-and hsh #x0F))
  (define u (if (< h 8) x y))
  (define v (cond [(< h 4) y] [(or (= h 12) (= h 14)) x] [else z]))
  (+ (if (bitwise-bit-set? h 0) (- u) u) (if (bitwise-bit-set? h 1) (- v) v)))

(define permutation
  (vector
   151 160 137 91 90 15 131 13 201 95 96 53 194 233 7 225 140 36 103 30 69 142 8 99 37 240 21 10 23
   190 6 148 247 120 234 75 0 26 197 62 94 252 219 203 117 35 11 32 57 177 33 88 237 149 56 87 174 20
   125 136 171 168 68 175 74 165 71 134 139 48 27 166 77 146 158 231 83 111 229 122 60 211 133 230 220
   105 92 41 55 46 245 40 244 102 143 54 65 25 63 161 1 216 80 73 209 76 132 187 208 89 18 169 200 196
   135 130 116 188 159 86 164 100 109 198 173 186 3 64 52 217 226 250 124 123 5 202 38 147 118 126 255
   82 85 212 207 206 59 227 47 16 58 17 182 189 28 42 223 183 170 213 119 248 152 2 44 154 163 70 221
   153 101 155 167 43 172 9 129 22 39 253 19 98 108 110 79 113 224 232 178 185 112 104 218 246 97 228
   251 34 242 193 238 210 144 12 191 179 162 241 81 51 145 235 249 14 239 107 49 192 214 31 181 199
   106 157 184 84 204 176 115 121 50 45 127 4 150 254 138 236 205 93 222 114 67 29 24 72 243 141 128
   195 78 66 215 61 156 180))

(define p (make-vector 512))
(for ((offset (in-list '(0 256))))
  (vector-copy! p offset permutation))

(define-syntax-rule (p-ref n)
  (vector-ref p n))

(define (noise x y z)
  (let*
      (
       ;; FIND UNIT CUBE THAT CONTAINS POINT.
       (X (floor-to-255 x))
       (Y (floor-to-255 y))
       (Z (floor-to-255 z))
       ; FIND RELATIVE X,Y,Z OF POINT IN CUBE.
       (x (- x (floor x)))
       (y (- y (floor y)))
       (z (- z (floor z)))
       ;; COMPUTE FADE CURVES FOR EACH OF X,Y,Z.
       (u (fade x))
       (v (fade y))
       (w (fade z))
       ;; HASH COORDINATES OF THE 8 CUBE CORNERS...
       (A  (+ (p-ref X) Y))
       (AA (+ (p-ref A) Z))
       (AB (+ (p-ref (add1 A)) Z))
       (B  (+ (p-ref (add1 X)) Y))
       (BA (+ (p-ref B) Z))
       (BB (+ (p-ref (add1 B)) Z)))
    ;; .. AND ADD BLENDED RESULTS FROM 8 CORNERS OF CUBE
    (lerp
     w
     (lerp
      v (lerp u (grad (p-ref AA) x y z) (grad (p-ref BA) (sub1 x) y z))
      (lerp u (grad (p-ref AB) x (sub1 y) z) (grad (p-ref BB) (sub1 x) (sub1 y) z)))
     (lerp
      v
      (lerp u (grad (p-ref (add1 AA)) x y (sub1 z)) (grad (p-ref (add1 BA)) (sub1 x) y (sub1 z)))
      (lerp u (grad (vector-ref p (add1 AB)) x (sub1 y) (sub1 z))
            (grad (vector-ref p (add1 BB)) (sub1 x) (sub1 y) (sub1 z)))))))

(module+ test
  (noise 3.14 42 7))
