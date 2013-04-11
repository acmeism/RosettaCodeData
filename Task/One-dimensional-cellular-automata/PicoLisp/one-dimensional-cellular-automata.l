(let Cells (chop "_###_##_#_#_#_#__#__")
   (do 10
      (prinl Cells)
      (setq Cells
         (make
            (link "_")
            (map
               '((L)
                  (case (head 3 L)
                     (`(mapcar chop '("___" "__#" "_#_" "#__" "###"))
                         (link "_") )
                     (`(mapcar chop '("_##" "#_#" "##_"))
                        (link "#") ) ) )
               Cells )
            (link "_") ) ) ) )
