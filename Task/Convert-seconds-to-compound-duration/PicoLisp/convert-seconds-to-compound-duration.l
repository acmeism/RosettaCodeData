(for Sec (7259 86400 6000000)
   (tab (-10 -30)
      Sec
      (glue ", "
         (extract
            '((N Str)
               (when (gt0 (/ Sec N))
                  (setq Sec (% Sec N))
                  (pack @ " " Str) ) )
            (604800 86400 3600 60 1)
            '("wk" "d" "hr" "min" "sec") ) ) ) )
