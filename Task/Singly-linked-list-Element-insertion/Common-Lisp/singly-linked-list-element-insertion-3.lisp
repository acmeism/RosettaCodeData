(defun insert-after (list new existing &key (test #'eql))
"Insert item new into list, before existing, or at the end if existing
is not present. The default comparison test function is EQL. This
function destroys the original list and returns the new list."
  (cond
    ;; case 1: list is empty: just return list of new
    ((endp list)
     (list new))
    ;; case 2: existing element is first element of list
    ((funcall test (car list) existing)
     `(,(car list) ,new ,@(cdr list)))
    ;; case 3: recurse: insert the element into the rest of the list,
    ;; and make that list the new rest.
    (t (rplacd list (insert-before (cdr list) new existing :test test))
       list)))
