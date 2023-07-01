(define (euler-method f y0 a b h)
  ;; Approximate y(t) in dy/dt=f(t,y), y(a)=y0, t going from a to b
  ;; with positive step size h. Produce a list of point pairs as
  ;; output.
  (let loop ((t a)
             (y y0)
             (point-pairs '()))
    (let ((point-pairs (cons (cons t y) point-pairs)))
      (if (<= b t)
          (reverse point-pairs)
          (loop (+ t h) (+ y (* h (f t y))) point-pairs)))))

(define (newton-cooling-step t Temperature)
  ;; Newton's cooling law, with temperature in Celsius:
  ;;
  ;;   f(t, Temperature) = -0.07*(Temperature - 20)
  ;;
  (* -0.07 (- Temperature 20)))

(define data-for-stepsize=2
  (euler-method newton-cooling-step 100.0 0.0 100.0 2.0))

(define data-for-stepsize=5
  (euler-method newton-cooling-step 100.0 0.0 100.0 5.0))

(define data-for-stepsize=10
  (euler-method newton-cooling-step 100.0 0.0 100.0 10.0))

(define (display-point-pairs point-pairs)
  (let loop ((p point-pairs))
    (if (pair? p)
        (begin
          (display (inexact (caar p)))
          (display " ")
          (display (inexact (cdar p)))
          (newline)
          (loop (cdr p))))))

(display "set encoding utf8") (newline)
(display "set term png size 1000,750 font 'Farao Book,16'") (newline)
(display "set output 'newton-cooling-Scheme.png'") (newline)
(display "set grid") (newline)
(display "set title 'Newton’s Law of Cooling'") (newline)
(display "set xlabel 'Elapsed time (seconds)'") (newline)
(display "set ylabel 'Temperature (Celsius)'") (newline)
(display "set xrange [0:100]") (newline)
(display "set yrange [15:100]") (newline)
(display "y(x) = 20.0 + (80.0 * exp (-0.07 * x))") (newline)
(display "plot y(x) with lines title 'Analytic solution', \\") (newline)
(display "     '-' with linespoints title 'Euler method, step size 2s', \\") (newline)
(display "     '-' with linespoints title 'Step size 5s', \\") (newline)
(display "     '-' with linespoints title 'Step size 10s'") (newline)
(display-point-pairs data-for-stepsize=2)
(display "e") (newline)
(display-point-pairs data-for-stepsize=5)
(display "e") (newline)
(display-point-pairs data-for-stepsize=10)
(display "e") (newline)
