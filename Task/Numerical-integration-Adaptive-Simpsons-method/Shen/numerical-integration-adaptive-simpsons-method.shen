(define simpson-rule
  F A FA B FB ->
    (let M (* 0.5 (+ A B))
         FM (F M)
         QuadVal (* (/ (- B A) 6.0) (+ FA (* 4.0 FM) FB))
         [M FM QuadVal]))

(define recursive-simpson
  F A FA B FB Tol Whole M FM Depth ->
    (let TheLeftStuff (simpson-rule F A FA M FM)
         TheRightStuff (simpson-rule F M FM B FB)
         (recursive-simpson-united F A FA B FB Tol Whole M FM Depth
                                   TheLeftStuff TheRightStuff)))

(define recursive-simpson-united
  F A FA B FB Tol Whole M FM Depth
  [LM FLM Left] [RM FRM Right] ->
    (let Delta (- (+ Left Right) Whole)
         Tol_ (* 0.5 Tol)
         (if (or (<= Depth 0)
                 (= Tol_ Tol)
                 (<= (abs Delta) (* 15.0 Tol)))
            (+ Left Right (/ Delta 15.0))
            (+ (recursive-simpson F A FA M FM Tol_
                                  Left LM FLM (- Depth 1))
               (recursive-simpson F M FM B FB Tol_
                                  Right RM FRM (- Depth 1))))))

(define quad-asr
  F A B Tol Depth ->
    (let FA (F A)
         FB (F B)
         TheWholeStuff (simpson-rule F A FA B FB)
         (quad-asr-part-two F A FA B FB Tol Depth TheWholeStuff)))

(define quad-asr-part-two
  F A FA B FB Tol Depth [M FM Whole] ->
    (recursive-simpson F A FA B FB Tol Whole M FM Depth))

\\ The Shen standard library contains only an unserious
\\ implementation of sin(x), so I might as well toss together
\\ my own! Thus: an uneconomized Maclaurin expansion. Gotten
\\ via "taylor(sin(x),x,0,20);" in Maxima. Using up to x**13
\\ should give an error bound on the order of 1e-12, for
\\ 0 <= x <= 1. That is much better than we need.
(define sin
  X -> (compute-sin X (* X X)))
(define compute-sin
  X XX ->
    (* X (+ 1.0
            (* XX (+ (/ -1.0 6.0)
                     (* XX (+ (/ 1.0 120.0)
                              (* XX (+ (/ -1.0 5040.0)
                                       (* XX (+ (/ 1.0 362880.0)
                                                (* XX (+ (/ -1.0 39916800.0)
                                                         (* XX (/ 1.0 6227020800.0)))))))))))))))

(define abs
  \\ Like sin, abs is in the standard library, but it is very
  \\ easy to write.
  X -> (if (< X 0) (- 0 X) X))

(output "estimate of the definite integral of sin x dx from 0 to 1: ")
(print (quad-asr (lambda x (sin x)) 0.0 1.0 1.0e-9 100))
(nl)

\\ local variables:
\\ mode: indented-text
\\ tab-width: 2
\\ end:
