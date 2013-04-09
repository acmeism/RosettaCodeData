(setq *Letters (apply circ (mapcar char (range 65 90))))

(de caesar (Str Key)
   (pack
      (mapcar '((C) (cadr (nth (member C *Letters) Key)))
         (chop (uppc Str)) ) ) )
