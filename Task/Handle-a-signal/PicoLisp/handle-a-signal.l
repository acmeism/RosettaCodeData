#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(push '*Bye '(println (*/ (usec) 1000000)) '(prinl))

(let Cnt 0
   (loop
      (println (inc 'Cnt))
      (wait 500) ) )
