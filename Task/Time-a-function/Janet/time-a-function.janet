(defmacro time
  "Print the time it takes to evaluate body to stderr.\n
  Evaluates to body."
  [body]
  (with-syms [$start $val]
    ~(let [,$start (os/clock)
           ,$val ,body]
       (eprint (- (os/clock) ,$start))
       ,$val)))

(time (os/sleep 0.5))
