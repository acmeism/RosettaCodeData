(defun insert-after (new-element old-element list &key (test 'eql))
  "Return a list like list, but with new-element appearing after the
first occurence of old-element. If old-element does not appear in
list, then a list returning just new-element is returned."
  (if (endp list) (list new-element)
    (do ((head (list (first list)) (cons (first tail) head))
         (tail (rest list) (rest tail)))
        ((or (endp tail) (funcall test old-element (first head)))
         (nreconc head (cons new-element tail))))))

(defun ninsert-after (new-element old-element list &key (test 'eql))
  "Like insert-after, but modifies list in place.  If list is empty, a
new list containing just new-element is returned."
  (if (endp list) (list new-element)
    (do ((prev list next)
         (next (cdr list) (cdr next)))
        ((or (null next) (funcall test old-element (car prev)))
         (rplacd prev (cons new-element next))
         list))))
