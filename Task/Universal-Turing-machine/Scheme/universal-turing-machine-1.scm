;----------------------------------------------------------------------------------------------

; The tape is a doubly-linked list of "cells".  Each cell is a pair in which the cdr points
; to the cell on its right, and the car is a vector containing: 0: the value of the cell;
; 1: pointer to the cell on this cell's left; 2: #t if the cell has never been written.

; Make a new cell with the given contents, but linked to no other cell(s).
; (This is the only place that a cell can be marked as un-written.)
(define make-cell
  (lambda (val . opt-unwrit)
    (list (vector val '() (if (pair? opt-unwrit) (car opt-unwrit) #f)))))

; Return the un-written flag of the cell.
(define cell-unwrit?
  (lambda (cell)
    (vector-ref (car cell) 2)))

; Return the value of the cell.
(define cell-get
  (lambda (cell)
    (vector-ref (car cell) 0)))

; Store the value of the cell.
; Clears the un-written flag of the cell.
(define cell-set!
  (lambda (cell val)
    (vector-set! (car cell) 0 val)
    (vector-set! (car cell) 2 #f)))

; Return the cell to the right of the given cell on the tape.
; Returns () if there is no cell to the right.
(define cell-right
  (lambda (cell)
    (cdr cell)))

; Return the cell to the left of the given cell on the tape.
; Returns () if there is no cell to the left.
(define cell-left
  (lambda (cell)
    (vector-ref (car cell) 1)))

; Return the cell to the right of the given cell on the tape.
; Extends the tape with the give blank symbol if there is no cell to the right.
; Optionally, passes the given un-written flag to make-cell (if needed).
(define cell-extend-right
  (lambda (cell blank . opt-unwrit)
    (if (null? (cdr cell))
      (let ((new (if (pair? opt-unwrit) (make-cell blank (car opt-unwrit)) (make-cell blank))))
        (vector-set! (car new) 1 cell)
        (set-cdr! cell new)
        new)
      (cell-right cell))))

; Return the cell to the left of the given cell on the tape.
; Extends the tape with the give blank symbol if there is no cell to the left.
; Optionally, passes the given un-written flag to make-cell (if needed).
(define cell-extend-left
  (lambda (cell blank . opt-unwrit)
    (if (null? (vector-ref (car cell) 1))
      (let ((new (if (pair? opt-unwrit) (make-cell blank (car opt-unwrit)) (make-cell blank))))
        (set-cdr! new cell)
        (vector-set! (car cell) 1 new)
        new)
      (cell-left cell))))

; Make a new tape whose cells contain the values in the given list.
; Optionally, pad the tape per the given blank symbol, left-padding and right-padding amounts.
(define make-tape
  (lambda (values . opt-pads)
    (unless (pair? values) (error 'make-tape "values argument is not a list" pads))
    (let* ((tape (make-cell (car values)))
           (last (do ((values (cdr values) (cdr values))
                      (cell tape (cell-extend-right cell (car values))))
                     ((null? values) cell))))
      (when (pair? opt-pads)
        (let ((blank (list-ref opt-pads 0))
              (left (list-ref opt-pads 1))
              (right (list-ref opt-pads 2)))
          (unless (and (integer? left) (integer? right))
            (error 'make-tape "padding arguments must be integers" opt-pads))
          (do ((count 0 (1+ count))
               (cell last (cell-extend-right cell blank #t)))
              ((>= count right)))
          (do ((count 0 (1+ count))
               (cell tape (cell-extend-left cell blank #t)))
              ((>= count left)))))
      tape)))

; Make a deep copy of the given tape.
; Note:  Only copies from the given cell forward.
(define tape-copy
  (lambda (tape)
    (let ((copy (make-cell (cell-get tape))))
      (do ((tape (cdr tape) (cdr tape))
           (cell copy (cell-extend-right cell (cell-get tape))))
          ((null? tape)))
      copy)))

; Return the first cell on a tape.
; Optionally, leading blank symbols are not included (will return last cell of blank tape).
(define tape-fst
  (lambda (cell . opt-blank)
    (let ((fst (do ((fst cell (cell-left fst))) ((null? (cell-left fst)) fst))))
      (if (null? opt-blank)
        fst
        (do ((fst fst (cell-right fst)))
            ((or (null? (cell-right fst)) (not (eq? (car opt-blank) (cell-get fst)))) fst))))))

; Return the last cell on a tape.
; Optionally, trailing blank symbols are not included (will return first cell of blank tape).
(define tape-lst
  (lambda (cell . opt-blank)
    (let ((lst (do ((lst cell (cell-right lst))) ((null? (cell-right lst)) lst))))
      (if (null? opt-blank)
        lst
        (do ((lst lst (cell-left lst)))
            ((or (null? (cell-left lst)) (not (eq? (car opt-blank) (cell-get lst)))) lst))))))

; Return true if the given tape is empty.  (I.e. contains nothing but blank symbols.)
(define tape-empty?
  (lambda (cell blank)
    (let ((fst (tape-fst cell blank)))
      (and (null? (cell-right fst)) (eq? blank (cell-get fst))))))

; Convert the contents of a tape to a string.
; Place a mark around the indicated cell (if any match).
; Prints the entire contents regardless of which cell is given.
; Optionally, leading and trailing instances of the given blank symbol are suppressed.
; The values of un-written cells are not shown, though space for them is included.
(define tape->string
  (lambda (cell mark . opt-blank)
    (let ((strlst (list #\[))
          (marked-prev #f)
          (fst (if (null? opt-blank) (tape-fst cell) (tape-fst cell (car opt-blank))))
          (lst (if (null? opt-blank) (tape-lst cell) (tape-lst cell (car opt-blank)))))
      (do ((cell fst (cell-right cell)))
          ((eq? cell (cell-right lst)))
        (let* ((mark-now (eq? cell mark))
               (fmtstr (cond (mark-now " {~a}") (marked-prev " ~a") (else "  ~a")))
               (value (if (and (not mark-now) (cell-unwrit? cell)) " " (cell-get cell))))
          (set! strlst (append strlst (string->list (format fmtstr value))))
          (set! marked-prev mark-now)))
      (list->string (append strlst (string->list (if marked-prev " ]" "  ]")))))))

;----------------------------------------------------------------------------------------------

; A Turing Machine contains the 7-tuple that formally defines it, stored in an array to
; make access relatively fast.  The transitions are stored in an association list keyed by
; the pair (q_i . s_j) for ease of lookup.

; Make a new Turing Machine from the given arguments:
; Symbols list, blank symbol, input symbols list, states list, initial state, final (accepting)
; states list, and list of transitions.  A transition is a 5-element list of: state (q_i),
; symbol read (s_i), symbol to write (s_ij), direction to move (d_ij), and next state (q_ij).
(define make-turing
  (lambda (symbols blank inputs states initial finals . transitions)
    ; Raise error if any element in list lst is not in list set.
    (define all-list-in-set
      (lambda (set lst msg)
        (for-each (lambda (val) (unless (memq val set) (error 'make-turing msg val))) lst)))
    ; Raise error if the given transition is not correctly formed.
    (define transition-validate
      (lambda (tran)
        (when (or (not (list? tran)) (not (= 5 (length tran))))
              (error 'make-turing "transition not a length-5 list" tran))
        (let ((q_i (list-ref tran 0))
              (s_j (list-ref tran 1))
              (s_ij (list-ref tran 2))
              (d_ij (list-ref tran 3))
              (q_ij (list-ref tran 4)))
          (unless (memq q_i states) (error 'make-turing "q_i not in states" q_i))
          (unless (memq s_j symbols) (error 'make-turing "s_j not in symbols" s_j))
          (unless (memq s_ij symbols) (error 'make-turing "s_ij not in symbols" s_ij))
          (unless (memq d_ij '(L R N)) (error 'make-turing "d_ij not in {L R N}" d_ij))
          (unless (memq q_ij states) (error 'make-turing "q_ij not in states" q_ij)))))
    ; Convert the given transitions list into an alist of transitions keyed by (q_i . s_j).
    (define transitions-alist
      (lambda (trns)
        (cond ((null? trns) '())
              (else (cons (cons (cons (caar trns) (cadar trns)) (list (cddar trns)))
                          (transitions-alist (cdr trns)))))))
    ; Validate all the arguments.
    (unless (list? symbols) (error 'make-turing "symbols not a list" symbols))
    (unless (memq blank symbols) (error 'make-turing "blank not in symbols" blank))
    (all-list-in-set symbols inputs "inputs not all in symbols")
    (unless (list? states) (error 'make-turing "states not a list" states))
    (unless (memq initial states) (error 'make-turing "initial not in states" initial))
    (all-list-in-set states finals "finals not all in states")
    (for-each (lambda (tran) (transition-validate tran)) transitions)
    ; Construct and return the Turing Machine tuple vector.
    (let ((tuple (make-vector 7)))
      (vector-set! tuple 0 symbols)
      (vector-set! tuple 1 blank)
      (vector-set! tuple 2 inputs)
      (vector-set! tuple 3 states)
      (vector-set! tuple 4 initial)
      (vector-set! tuple 5 finals)
      (vector-set! tuple 6 (transitions-alist transitions))
      tuple)))

; Return the symbols of a Turing Machine.
(define-syntax turing-symbols (syntax-rules () ((_ tm) (vector-ref tm 0))))

; Return the blank symbol of a Turing Machine.
(define-syntax turing-blank (syntax-rules () ((_ tm) (vector-ref tm 1))))

; Return the input symbols of a Turing Machine.
(define-syntax turing-inputs (syntax-rules () ((_ tm) (vector-ref tm 2))))

; Return the states of a Turing Machine.
(define-syntax turing-states (syntax-rules () ((_ tm) (vector-ref tm 3))))

; Return the initial state of a Turing Machine.
(define-syntax turing-initial (syntax-rules () ((_ tm) (vector-ref tm 4))))

; Return the final states of a Turing Machine.
(define-syntax turing-finals (syntax-rules () ((_ tm) (vector-ref tm 5))))

; Return the transitions of a Turing Machine.
(define-syntax turing-transitions (syntax-rules () ((_ tm) (vector-ref tm 6))))

; Return the q_i (current state) of alist element transition.
(define-syntax tran-q_i (syntax-rules () ((_ atran) (car (car atran)))))

; Return the s_j (symbol read from the tape) of alist element transition.
(define-syntax tran-s_j (syntax-rules () ((_ atran) (cdr (car atran)))))

; Return the s_ij (symbol written) of alist element transition.
(define-syntax tran-s_ij (syntax-rules () ((_ atran) (car (cadr atran)))))

; Return the d_ij (direction of move) of alist element transition.
(define-syntax tran-d_ij (syntax-rules () ((_ atran) (cadr (cadr atran)))))

; Return the q_ij (state transition) of alist element transition.
(define-syntax tran-q_ij (syntax-rules () ((_ atran) (caddr (cadr atran)))))

; Lookup the transition matching the given state and symbol in the given Turing Machine.
(define atrns-lookup
  (lambda (state symbol tm)
    (assoc (cons state symbol) (turing-transitions tm))))

; Convert the given Turing Machine transition to a string.
(define tran->string
  (lambda (atran)
    (format "(~a ~a ~a ~a ~a)"
      (tran-q_i atran) (tran-s_j atran) (tran-s_ij atran) (tran-d_ij atran) (tran-q_ij atran))))

; Convert the given Turing Machine definition to a string.
; Options (zero or more) are, in order: component prefix string (default "");
; component suffix string (default ""); component separator string (default newline).
(define turing->string
  (lambda (tm . opts)
    (let ((prestr (if (> (length opts) 0) (list-ref opts 0) ""))
          (sufstr (if (> (length opts) 1) (list-ref opts 1) ""))
          (sepstr (if (> (length opts) 2) (list-ref opts 2) (make-string 1 #\newline)))
          (strlst '()))
      (set! strlst (append strlst (string->list
        (format "~a~a~a~a" prestr (turing-symbols tm) sufstr sepstr))))
      (set! strlst (append strlst (string->list
        (format "~a~a~a~a" prestr (turing-blank tm) sufstr sepstr))))
      (set! strlst (append strlst (string->list
        (format "~a~a~a~a" prestr (turing-inputs tm) sufstr sepstr))))
      (set! strlst (append strlst (string->list
        (format "~a~a~a~a" prestr (turing-states tm) sufstr sepstr))))
      (set! strlst (append strlst (string->list
        (format "~a~a~a~a" prestr (turing-initial tm) sufstr sepstr))))
      (set! strlst (append strlst (string->list
        (format "~a~a~a~a" prestr (turing-finals tm) sufstr
          (if (> (length (turing-transitions tm)) 0) sepstr "")))))
      (do ((index 0 (1+ index)))
          ((>= index (length (turing-transitions tm))))
        (set! strlst (append strlst (string->list
          (format "~a~a~a~a" prestr (tran->string (list-ref (turing-transitions tm) index)) sufstr
            (if (< index (1- (length (turing-transitions tm)))) sepstr ""))))))
      (list->string strlst))))

;----------------------------------------------------------------------------------------------

; Run the given Turing Machine on the given input tape.
; If specified, display log of progress.  Optionally, abort after given number of iterations.
; Returns the count of iterations, the accepting state (if one; else void), and the output
; tape as multiple values.
(define turing-run
  (lambda (tm cell show-log? . opt-abort)
    ; Validate contents of input tape.  (Leading/trailing blanks allowed; internals are not.)
    (unless (tape-empty? cell (turing-blank tm))
      (let ((fst (tape-fst cell (turing-blank tm)))
            (lst (tape-lst cell (turing-blank tm))))
        (if (eq? fst lst)
          (unless (memq (cell-get fst) (turing-symbols tm))
            (error 'turing-run "input tape has disallowed content" (cell-get fst)))
          (do ((cell fst (cell-right cell)))
              ((eq? cell (cell-right lst)))
            (unless (memq (cell-get cell) (turing-inputs tm))
                  (error 'turing-run "input tape has disallowed content" (cell-get cell)))))))
    ; Initialize state and head.
    (let ((state (turing-initial tm)) (head cell) (atran #f)
          (abort (and (pair? opt-abort) (integer? (car opt-abort))
                      (> (car opt-abort) 0) (car opt-abort))))
      ; Loop until no transition matches state/symbol or reached a final state.
      (do ((count 0 (1+ count))
           (atran (atrns-lookup state (cell-get head) tm)
                  (atrns-lookup state (cell-get head) tm)))
          ((or (not atran) (memq state (turing-finals tm)) (and abort (>= count abort)))
           ; Display final progress (optional).
           (when show-log?
             (let* ((string (format "~a" state))
                    (strlen (string-length string))
                    (padlen (max 1 (- 25 strlen)))
                    (strpad (make-string padlen #\ )))
               (printf "~a~a~a~%" string strpad (tape->string cell head))))
           ; Return resultant count, accepting state (or void), and tape.
           (values count (if (memq state (turing-finals tm)) state (void)) head))
        ; Display progress (optional).
        (when show-log?
          (let* ((string (format "~a ~a  ->  ~a ~a ~a" state (cell-get head)
                                 (tran-s_ij atran) (tran-d_ij atran) (tran-q_ij atran)))
                 (strlen (string-length string))
                 (padlen (max 1 (- 25 strlen)))
                 (strpad (make-string padlen #\ )))
            (printf "~a~a~a~%" string strpad (tape->string cell head))))
        ; Iterate.
        (cell-set! head (tran-s_ij atran))
        (set! state (tran-q_ij atran))
        (set! head (case (tran-d_ij atran)
                         ((L) (cell-extend-left head (turing-blank tm)))
                         ((R) (cell-extend-right head (turing-blank tm)))
                         ((N) head)))))))

;----------------------------------------------------------------------------------------------
