(setq FunList
   (make
      (for @N 10
         (link (curry (@N) () (* @N @N))) ) ) )
