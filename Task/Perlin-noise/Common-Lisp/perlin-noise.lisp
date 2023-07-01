;;;; Translation from: Java

(declaim (optimize (speed 3) (debug 0)))

(defconstant +p+
  (let ((permutation
	 #(151 160 137 91 90 15
	   131 13 201 95 96 53 194 233 7 225 140 36 103 30 69 142 8 99 37 240 21 10 23
	   190  6 148 247 120 234 75 0 26 197 62 94 252 219 203 117 35 11 32 57 177 33
	   88 237 149 56 87 174 20 125 136 171 168  68 175 74 165 71 134 139 48 27 166
	   77 146 158 231 83 111 229 122 60 211 133 230 220 105 92 41 55 46 245 40 244
	   102 143 54  65 25 63 161  1 216 80 73 209 76 132 187 208  89 18 169 200 196
	   135 130 116 188 159 86 164 100 109 198 173 186  3 64 52 217 226 250 124 123
	   5 202 38 147 118 126 255 82 85 212 207 206 59 227 47 16 58 17 182 189 28 42
	   223 183 170 213 119 248 152  2 44 154 163  70 221 153 101 155 167  43 172 9
	   129 22 39 253  19 98 108 110 79 113 224 232 178 185  112 104 218 246 97 228
	   251 34 242 193 238 210 144 12 191 179 162 241  81 51 145 235 249 14 239 107
	   49 192 214  31 181 199 106 157 184  84 204 176 115 121 50 45 127  4 150 254
	   138 236 205 93 222 114 67 29 24 72 243 141 128 195 78 66 215 61 156 180))
	(aux (make-array 512 :element-type 'fixnum)))
    (dotimes (i 256 aux)
      (setf (aref aux i) (aref permutation i))
      (setf (aref aux (+ 256 i)) (aref permutation i)))))

(defun fade (te)
  (declare (type double-float te))
  (the double-float (* te te te (+ (* te (- (* te 6) 15)) 10))))

(defun lerp (te a b)
  (declare (type double-float te a b))
  (the double-float (+ a (* te (- b a)))))

(defun grad (hash x y z)
  (declare (type fixnum hash)
	   (type double-float x y z))
  (let* ((h (logand hash 15)) ;; convert lo 4 bits of hash code into 12 gradient directions
	 (u (if (< h 8) x y))
	 (v (cond ((< h 4)
		   y)
		  ((or (= h 12) (= h 14))
		   x)
		  (t z))))
    (the
     double-float
     (+
      (if (zerop (logand h 1)) u (- u))
      (if (zerop (logand h 2)) v (- v))))))

(defun noise (x y z)
  (declare (type double-float x y z))
  ;; find unit cube that contains point.
  (let ((cx (logand (floor x) 255))
	(cy (logand (floor y) 255))
	(cz (logand (floor z) 255)))
    ;; find relative x, y, z of point in cube.
    (let ((x (- x (floor x)))
	  (y (- y (floor y)))
	  (z (- z (floor z))))
      ;; compute fade curves for each of x, y, z.
      (let ((u (fade x))
	    (v (fade y))
	    (w (fade z)))
	;; hash coordinates of the 8 cube corners,
	(let* ((ca  (+ (aref +p+     cx)  cy))
	       (caa (+ (aref +p+     ca)  cz))
	       (cab (+ (aref +p+ (1+ ca)) cz))
	       (cb  (+ (aref +p+ (1+ cx)) cy))
	       (cba (+ (aref +p+     cb)  cz))
	       (cbb (+ (aref +p+ (1+ cb)) cz)))
	  ;; ... and add blended results from 8 corners of cube
	  (the double-float
	       (lerp w
		     (lerp v
			   (lerp u
				 (grad (aref +p+ caa)          x       y      z)
				 (grad (aref +p+ cba)      (1- x)      y      z))
			   (lerp u
				 (grad (aref +p+ cab)          x   (1- y)     z)
				 (grad (aref +p+ cbb)      (1- x)  (1- y)     z)))
		     (lerp v
			   (lerp u
				 (grad (aref +p+ (1+ caa))     x       y  (1- z))
				 (grad (aref +p+ (1+ cba)) (1- x)      y  (1- z)))
			   (lerp u
				 (grad (aref +p+ (1+ cab))     x   (1- y) (1- z))
				 (grad (aref +p+ (1+ cbb)) (1- x)  (1- y) (1- z)))))))))))

(print (noise 3.14d0 42d0 7d0))
