(macro (ainc! Alist Key Value Function (Deflt 0))
  (local (E-Message K Val Func)
    (setq K Key)
    (setq Func Function)
    (if (true? Func)
      (setq Val Value)
      (begin (setq Func +) (setq Val (or Value 1))))
    (unless
      (catch
        (setf (assoc K Alist)
          (list ($it 0) (Func Val ($it 1))))
        'E-Message)
      (if (starts-with E-Message "ERR: no reference")
        (setf Alist (cons (list K (Func Val Deflt)) Alist))
        (throw-error E-Message)))))

(setq alist '())
(ainc! alist 'b 22)
(ainc! alist 'b)
(ainc! alist 'name "Fred" or)
(ainc! alist 'letters 'h cons '())
(ainc! alist 'letters 'o cons)

(println alist)
