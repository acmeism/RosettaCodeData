(mapc (lambda (&rest args)
        (format t "~{~A~}~%" args))
      '(|a| |b| |c|)
      '(a b c)
      '(1 2 3))
