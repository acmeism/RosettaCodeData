(defun buckets (numbers)
  (loop with min = (apply #'min numbers)
        with max = (apply #'max numbers)
        with width = (/ (- max min) 7)
        for base from (- min (/ width 2)) by width
        repeat 8
        collect (cons base (+ base width))))

(defun bucket-for-number (number buckets)
  (loop for i from 0
        for (min . max) in buckets
        when (and (<= min number) (< number max))
          return i))

(defun sparkline (numbers)
  (loop with buckets = (buckets numbers)
        with sparks = "▁▂▃▄▅▆▇█"
        with sparkline = (make-array (length numbers) :element-type 'character)
        with min = (apply #'min numbers)
        with max = (apply #'max numbers)
        for number in numbers
        for i from 0
        for bucket = (bucket-for-number number buckets)
        do (setf (aref sparkline i) (char sparks bucket))
        finally (format t "Min: ~A, Max: ~A, Range: ~A~%" min max (- max min))
                (write-line sparkline)))

(defun string->numbers (string)
  (flet ((delimiterp (c)
           (or (char= c #\Space) (char= c #\,))))
    (loop for prev-end = 0 then end
          while prev-end
          for start = (position-if-not #'delimiterp string :start prev-end)
          for end = (position-if #'delimiterp string :start start)
          for number = (read-from-string string t nil :start start :end end)
          do (assert (numberp number))
          collect number)))

(defun string->sparkline (string)
  (sparkline (string->numbers string)))

(string->sparkline "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1")
(string->sparkline "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5")
