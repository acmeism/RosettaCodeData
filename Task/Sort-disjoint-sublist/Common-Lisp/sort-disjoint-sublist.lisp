(defun disjoint-sort (values indices)
  "Destructively perform a disjoin sublist sort on VALUES with INDICES."
  (loop :for element :in
     (sort (loop :for index :across indices
              :collect (svref values index))
           '<)
     :for index :across (sort indices '<)
     :do (setf (svref values index) element))
  values)
