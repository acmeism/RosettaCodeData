(defun fill-knapsack (items max-volume max-weight)
  "Items is a list of lists of the form (name value weight volume) where weight
and value are integers. max-volume and max-weight, also integers, are the
maximum volume and weight of the knapsack. fill-knapsack returns a list of the
form (total-value inventory total-volume total-weight) where total-value is the
total-value of a knapsack packed with inventory (a list whose elements are
elements of items), and total-weight and total-volume are the total weights and
volumes of the inventory."
  ;; maxes is a table indexed by volume and weight, where maxes[volume,weight]
  ;; is a list of the form (value inventory used-volume used-weight) where
  ;; inventory is a list of items of maximum value fitting within volume and
  ;; weight, value is the maximum value, and used-volume/used-weight are the
  ;; actual volume/weight of the inventory.
  (let* ((VV (1+ max-volume))
         (WW (1+ max-weight))
         (maxes (make-array (list VV WW))))
    ;; fill in the base cases where volume or weight is 0
    (dotimes (v VV) (setf (aref maxes v 0) (list 0 '() 0 0)))
    (dotimes (w WW) (setf (aref maxes 0 w) (list 0 '() 0 0)))
    ;; populate the rest of the table. The best value for a volume/weight
    ;; combination is the best way of adding an item to any of the inventories
    ;; from [volume-1,weight], [volume,weight-1], or [volume-1,weight-1], or the
    ;; best of these, if no items can be added.
    (do ((v 1 (1+ v))) ((= v VV) (aref maxes max-volume max-weight))
      (do ((w 1 (1+ w))) ((= w WW))
        (let ((options (sort (list (aref maxes v (1- w))
                                   (aref maxes (1- v) w)
                                   (aref maxes (1- v) (1- w)))
                             '> :key 'first)))
          (destructuring-bind (b-value b-items b-volume b-weight) (first options)
            (dolist (option options)
              (destructuring-bind (o-value o-items o-volume o-weight) option
                (dolist (item items)
                  (destructuring-bind (_ i-value i-volume i-weight) item
                    (declare (ignore _))
                    (when (and (<= (+ o-volume i-volume) v)
                               (<= (+ o-weight i-weight) w)
                               (>  (+ o-value  i-value)  b-value))
                      (setf b-value  (+ o-value  i-value)
                            b-volume (+ o-volume i-volume)
                            b-weight (+ o-weight i-weight)
                            b-items  (list* item o-items)))))))
            (setf (aref maxes v w)
                  (list b-value b-items b-volume b-weight))))))))
