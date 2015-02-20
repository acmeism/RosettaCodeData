(de Lst
   "*****             *               "
   "*   * *           *    *          "
   "*   *   **** **** *      **** ****"
   "***** * *    *  * *    * *  * *  *"
   "*     * *    *  * *    *  *   ****"
   "*     * *    *  * *    *   *  *   "
   "*     * *    *  * *    * *  * *   "
   "*     * **** **** **** * **** *   " )

(de transform (Lst A B)
   (make
      (chain (need (length Lst) " "))
      (for (L (chop (car Lst)) L)
         (ifn (= "*" (pop 'L))
            (link " " " " " ")
            (chain (need 3 A))
            (when (sp? (car L))
               (link B " " " ")
               (pop 'L) ) ) ) ) )

(prinl (transform Lst "/" "\\"))

(mapc
   '((X Y)
      (mapc
         '((A B)
            (prin (if (sp? B) A B)) )
            X
            Y )
      (prinl) )
   (maplist '((X) (transform X "\\" "/")) Lst)
   (maplist '((X) (transform X "/" "\\")) (cdr Lst)) )

(bye)
