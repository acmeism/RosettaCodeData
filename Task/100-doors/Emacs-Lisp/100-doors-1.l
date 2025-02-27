(defun create-doors ()
  "Returns a list of closed doors

Each door only has two status: open or closed.
If a door is closed it has the value 0, if it's open it has the value 1."
  (let ((return_value '(0))
         ;; There is already a door in the return_value, so k starts at 1
         ;; otherwise we would need to compare k against 99 and not 100 in
         ;; the while loop
         (k 1))
    (while (< k 100)
      (setq return_value (cons 0 return_value))
      (setq k (+ 1 k)))
    return_value))

(defun toggle-single-door (doors)
  "Toggle the stat of the door at the `car' position of the DOORS list

DOORS is a list of integers with either the value 0 or 1 and it represents
a row of doors.

Returns a list where the `car' of the list has it's value toggled (if open
it becomes closed, if closed it becomes open)."
  (if (= (car doors) 1)
    (cons 0 (cdr doors))
    (cons 1 (cdr doors))))

(defun toggle-doors (doors step original-step)
  "Step through all elements of the doors' list and toggle a door when step is 1

DOORS is a list of integers with either the value 0 or 1 and it represents
a row of doors.
STEP is the number of doors we still need to transverse before we arrive
at a door that has to be toggled.
ORIGINAL-STEP is the value of the argument step when this function is
called for the first time.

Returns a list of doors"
  (cond ((null doors)
          '())
    ((= step 1)
      (cons (car (toggle-single-door doors))
        (toggle-doors (cdr doors) original-step original-step)))
    (t
      (cons (car doors)
        (toggle-doors (cdr doors) (- step 1) original-step)))))

(defun main-program ()
  "The main loop for the program"
  (let ((doors_list (create-doors))
         (k 1)
         ;; We need to define max-specpdl-size and max-specpdl-size to big
         ;; numbers otherwise the loop reaches the max recursion depth and
         ;; throws an error.
         ;; If you want more information about these variables, press Ctrl
         ;; and h at the same time and then press v and then type the name
         ;; of the variable that you want to read the documentation.
         (max-specpdl-size 5000)
         (max-lisp-eval-depth 2000))
    (while (< k 101)
      (setq doors_list (toggle-doors doors_list k k))
      (setq k (+ 1 k)))
    doors_list))

(defun print-doors (doors)
  "This function prints the values of the doors into the current buffer.

DOORS is a list of integers with either the value 0 or 1 and it represents
a row of doors.
"
  ;; As in the main-program function, we need to set the variable
  ;; max-lisp-eval-depth to a big number so it doesn't reach max recursion
  ;; depth.
  (let ((max-lisp-eval-depth 5000))
    (unless (null doors)
      (insert (int-to-string (car doors)))
      (print-doors (cdr doors)))))

;; Returns a list with the final solution
(main-program)

;; Print the final solution on the buffer
(print-doors (main-program))
