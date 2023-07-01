(defn fahrenheit->celsius [deg-f]
  (/ (* (- deg-f 32) 5) 9))

(defn celsius->kelvin [deg-c]
  (+ deg-c 273.15))

(def fahrenheit->kelvin (comp celsius->kelvin fahrenheit->celsius))

(fahrenheit->kelvin 72) // 295.372
