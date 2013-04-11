(load "@lib/xm.l")

(mapcar
   '((L) (attr L 'Name))
   (body (in "file.xml" (xml))) )
