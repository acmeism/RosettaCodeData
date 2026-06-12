;;;;the expected result is:1001010010100
;;;little tools
(defun add-number-to-end (original-number additional-number)
  ;;add number to the end
  (format nil "~A~A" original-number additional-number))
(defun where-group2 (mix-list)
  ;;search where group2 occurs in a list
  (do ((index 1 (+ index 1)) (long (length mix-list)))
    ((or (>= index long) (not (equal (nth index mix-list) (nth (- index 1) mix-list))))
    index)))
(defun range-append (lists)
  ;;append group2 to group1
  (let ((ret (append-subsititute lists)))
    (if (second ret)
        (range-append ret)
        (car ret))))
(defun cut-to-2groups (mix-list jndex)
  ;;cut list to 2 lists with jndex
  (let ((group1 '()))
    (do ((index 0 (+ index 1))) ((>= index jndex)) (push (pop mix-list) group1))
    (list group1 mix-list)))
(defun output (output-list)
  ;;format & print
  (mapcar #'(lambda (i)
    (when i (mapcar #'(lambda (j) (princ (format nil "~A" j))) i)))
    output-list))
;;;big parts
(defun append-subsititute (lists)
  ;;append substitute the second group into the first group
  (let
    ((list1 (car lists))
    (list2 (second lists)))
    (do
      ((index 0 (+ index 1))
      (new-list '())
      (append-len (min (length list1) (length list2))))
      ((>= index append-len)
        (list (if list1 (append new-list list1) new-list) list2))
      (push (add-number-to-end (pop list1) (pop list2)) new-list))))
;;;main
(defun euclidean-rhythm (one-quantity number-quantity)
  ;;main function
  (let (number-list '())
    (setf number-list (list
      (make-list one-quantity :initial-element "1")
      (make-list (- number-quantity one-quantity) :initial-element "0")));init
    (do ((group2 0)) ((> 2 (- (+ (length (car number-list)) (length (second number-list))) group2)))
      (setf group2 (where-group2 (range-append number-list)))
      (setf number-list (cut-to-2groups (range-append number-list) group2)));calculate
    number-list))
;;print result
(output (euclidean-rhythm 5 13))
