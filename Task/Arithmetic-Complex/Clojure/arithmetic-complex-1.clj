(deftype Complex [real imag]
  Object
  (toString [this] (str real " " imag "j")))

(defn c-add [^Complex a ^Complex b]
  (Complex. (+ (.real a) (.real b))
            (+ (.imag a) (.imag b))))

(defn c-mul [^Complex a ^Complex b]
  (Complex. (- (* (.real a) (.real b)) (* (.imag a) (.imag b)))
            (+ (* (.real a) (.imag b)) (* (.imag a) (.real b)))))

(defn c-neg [^Complex a]
  (Complex. (- (.real a)) (- (.imag a))))

(defn c-inv [^Complex a]
  (let [r (.real a)
        i (.imag a)
        m (+ (* r r) (* i i))]
    (Complex. (/ r m) (- (/ i m)))))

(defn c-conj [^Complex a]
  (Complex. (.real a) (- (.imag a))))
