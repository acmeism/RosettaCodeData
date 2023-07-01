(load "@lib/xm.l")

(let Sections (body (in "file.xml" (xml)))
   (pretty (car (body (car Sections))))
   (prinl)
   (for S Sections
      (for L (body S)
         (prinl (car (body L 'price))) ) )
   (make
      (for S Sections
         (for L (body S)
            (link (car (body L 'name))) ) ) ) )
