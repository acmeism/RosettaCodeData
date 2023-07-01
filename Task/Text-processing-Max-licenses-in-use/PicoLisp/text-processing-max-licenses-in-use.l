#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(zero Count MaxCount)

(in (opt)
   (while (split (line) " ")
      (case (pack (cadr (setq Line @)))
         (IN
            (dec 'Count) )
         (OUT
            (let Time (cadddr Line)
               (cond
                  ((> (inc 'Count) MaxCount)
                     (setq MaxCount Count  MaxTimes Time) )
                  ((= Count MaxCount)
                     (setq MaxTimes (pack MaxTimes " and " Time)) ) ) ) ) ) ) )

(prinl "The biggest number of licenses is " MaxCount " at " MaxTimes " !")
(bye)
