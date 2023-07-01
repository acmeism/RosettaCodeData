((fn [x] (* x x) 5) ; Define a lambda and call it with 5.

(macroexpand-1 '(->> 5 (fn [x] (* x x))))
(fn [x] (* x x) 5)  ; Define a lambda that returns 5 regardless.
