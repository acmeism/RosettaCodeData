(lib 'math.lib)
Lib: math.lib loaded.
(define fp ' ( 0 2 -3 1))
(poly->string 'x fp) → x^3 -3x^2 +2x
(poly->html 'x fp) → x<sup>3</sup> -3x<sup>2</sup> +2x
(define (f x) (poly x fp))
(math-precision 1.e-6) → 0.000001

(root f -1000 1000) → 2.0000000133245677 ;; 2
(root f -1000 (- 2 epsilon)) → 1.385559938161431e-7 ;; 0
(root f epsilon (- 2 epsilon)) → 1.0000000002190812 ;; 1
