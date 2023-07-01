#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
(progn ;;init forms
  (ros:ensure-asdf)
  #+quicklisp(ql:quickload '() :silent t)
  )

(defpackage :ros.script.vm.3858678051
  (:use :cl))
(in-package :ros.script.vm.3858678051)

;;;
;;; The Rosetta Code Virtual Machine, in Common Lisp.
;;;
;;; Notes:
;;;
;;;   * I have tried not to use foreign types or similar means of
;;;     optimization.
;;;
;;;   * Integers are stored in the VM's executable memory in
;;;     big-endian order. Not because I prefer it, but because I do
;;;     not want to get myself into a little-endian rut.
;;;

(require "cl-ppcre")
(require "trivia")

;;; Yes, I could compute how much memory is needed, or I could assume
;;; that the instructions are in address order. However, for *this*
;;; implementation I am going to use a large fixed-size memory and use
;;; the address fields of instructions to place the instructions.
(defconstant executable-memory-size 65536
  "The size of memory for executable code, in 8-bit words.")

;;; Similarly, I am going to have fixed size data and stack memory.
(defconstant data-memory-size 2048
  "The size of memory for stored data, in 32-bit words.")
(defconstant stack-memory-size 2048
  "The size of memory for the stack, in 32-bit words.")

;;; And so I am going to have specialized types for the different
;;; kinds of memory the platform contains. Also for its "word" and
;;; register types.
(deftype word ()
  '(unsigned-byte 32))
(deftype register ()
  '(simple-array word (1)))
(deftype executable-memory ()
  `(simple-array (unsigned-byte 8) ,(list executable-memory-size)))
(deftype data-memory ()
  `(simple-array word ,(list data-memory-size)))
(deftype stack-memory ()
  `(simple-array word ,(list stack-memory-size)))

(defconstant re-blank-line
  (ppcre:create-scanner "^\\s*$"))

(defconstant re-parse-instr-1
  (ppcre:create-scanner "^\\s*(\\d+)\\s*(.*\\S)"))

(defconstant re-parse-instr-2
  (ppcre:create-scanner "(?i)^(\\S+)\\s*(.*)"))

(defconstant re-parse-instr-3
  (ppcre:create-scanner "^[[(]?([0-9-]+)"))

(defconstant opcode-names
  #("halt"
    "add"
    "sub"
    "mul"
    "div"
    "mod"
    "lt"
    "gt"
    "le"
    "ge"
    "eq"
    "ne"
    "and"
    "or"
    "neg"
    "not"
    "prtc"
    "prti"
    "prts"
    "fetch"
    "store"
    "push"
    "jmp"
    "jz"))

(defun blank-line-p (s)
  (not (not (ppcre:scan re-blank-line s))))

(defun opcode-from-name (s)
  (position-if (lambda (name)
                 (string= s name))
               opcode-names))

(defun create-executable-memory ()
  (coerce (make-list executable-memory-size
                     :initial-element (opcode-from-name "halt"))
          'executable-memory))

(defun create-data-memory ()
  (coerce (make-list data-memory-size :initial-element 0)
          'data-memory))

(defun create-stack-memory ()
  (coerce (make-list stack-memory-size :initial-element 0)
          'stack-memory))

(defun create-register ()
  (coerce (make-list 1 :initial-element 0) 'register))

(defstruct machine
  (sp (create-register) :type register) ; Stack pointer.
  (ip (create-register) :type register) ; Instruction pointer (same
  ; thing as program counter).
  (code (create-executable-memory) :type executable-memory)
  (data (create-data-memory) :type data-memory)
  (stack (create-stack-memory) :type stack-memory)
  (strings nil)
  output *standard-output*)

(defun insert-instruction (memory instr)
  (declare (type executable-memory memory))
  (trivia:match instr
    ((list address opcode arg)
     (let ((instr-size (if arg 5 1)))
       (unless (<= (+ address instr-size) executable-memory-size)
         (warn "the VM's executable memory size is exceeded")
         (uiop:quit 1))
       (setf (elt memory address) opcode)
       (when arg
         ;; Big-endian order.
         (setf (elt memory (+ address 1)) (ldb (byte 8 24) arg))
         (setf (elt memory (+ address 2)) (ldb (byte 8 16) arg))
         (setf (elt memory (+ address 3)) (ldb (byte 8 8) arg))
         (setf (elt memory (+ address 4)) (ldb (byte 8 0) arg)))))))

(defun load-executable-memory (memory instr-lst)
  (declare (type executable-memory memory))
  (loop for instr in instr-lst
        do (insert-instruction memory instr)))

(defun parse-instruction (s)
  (if (blank-line-p s)
      nil
      (let* ((strings (nth-value 1 (ppcre:scan-to-strings
                                    re-parse-instr-1 s)))
             (address (parse-integer (elt strings 0)))
             (split (nth-value 1 (ppcre:scan-to-strings
                                  re-parse-instr-2 (elt strings 1))))
             (opcode-name (string-downcase (elt split 0)))
             (opcode (opcode-from-name opcode-name))
             (arguments (elt split 1))
             (has-arg (trivia:match opcode-name
                        ((or "fetch" "store" "push" "jmp" "jz") t)
                        (_ nil))))
        (if has-arg
            (let* ((argstr-lst
                     (nth-value 1 (ppcre:scan-to-strings
                                   re-parse-instr-3 arguments)))
                   (argstr (elt argstr-lst 0)))
              `(,address ,opcode ,(parse-integer argstr)))
            `(,address ,opcode ())))))

(defun read-instructions (inpf)
  (loop for line = (read-line inpf nil 'eoi)
        until (eq line 'eoi)
        for instr = (parse-instruction line)
        when instr collect instr))

(defun read-datasize-and-strings-count (inpf)
  (let ((line (read-line inpf)))
    (multiple-value-bind (_whole-match strings)
        ;; This is a permissive implementation.
        (ppcre:scan-to-strings
         "(?i)^\\s*Datasize\\s*:\\s*(\\d+)\\s*Strings\\s*:\\s*(\\d+)"
         line)
      (declare (ignore _whole-match))
      `(,(parse-integer (elt strings 0))
        ,(parse-integer (elt strings 1))))))

(defun parse-string-literal (s)
  ;; This is a permissive implementation, but only in that it skips
  ;; any leading space. It does not check carefully for outright
  ;; mistakes.
  (let* ((s (ppcre:regex-replace "^\\s*" s ""))
         (quote-mark (elt s 0))
         (i 1)
         (lst
           (loop until (char= (elt s i) quote-mark)
                 collect (let ((c (elt s i)))
                           (if (char= c #\\)
                               (let ((c0 (trivia:match (elt s (1+ i))
                                           (#\n #\newline)
                                           (c1 c1))))
                                 (setq i (+ i 2))
                                 c0)
                               (progn
                                 (setq i (1+ i))
                                 c))))))
    (coerce lst 'string)))

(defun read-string-literals (inpf strings-count)
  (loop for i from 1 to strings-count
        collect (parse-string-literal (read-line inpf))))

(defun open-inpf (inpf-filename)
  (if (string= inpf-filename "-")
      *standard-input*
      (open inpf-filename :direction :input)))

(defun open-outf (outf-filename)
  (if (string= outf-filename "-")
      *standard-output*
      (open outf-filename :direction :output
                          :if-exists :overwrite
                          :if-does-not-exist :create)))

(defun word-signbit-p (x)
  "True if and only if the sign bit is set."
  (declare (type word x))
  (/= 0 (logand x #x80000000)))

(defun word-add (x y)
  "Addition with overflow freely allowed."
  (declare (type word x))
  (declare (type word y))
  (coerce (logand (+ x y) #xFFFFFFFF) 'word))

(defun word-neg (x)
  "The two's complement."
  (declare (type word x))
  (word-add (logxor x #xFFFFFFFF) 1))

(defun word-sub (x y)
  "Subtraction with overflow freely allowed."
  (declare (type word x))
  (declare (type word y))
  (word-add x (word-neg y)))

(defun word-mul (x y)
  "Signed multiplication."
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (let ((abs-x (if x<0 (word-neg x) x))
          (abs-y (if y<0 (word-neg y) y)))
      (let* ((abs-xy (the word
                          (logand (* abs-x abs-y) #xFFFFFFFF))))
        (if x<0
            (if y<0 abs-xy (word-neg abs-xy))
            (if y<0 (word-neg abs-xy) abs-xy))))))

(defun word-div (x y)
  "The quotient after signed integer division with truncation towards
zero."
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (let ((abs-x (if x<0 (word-neg x) x))
          (abs-y (if y<0 (word-neg y) y)))
      (let* ((abs-x/y (the word
                           (logand (floor abs-x abs-y) #xFFFFFFFF))))
        (if x<0
            (if y<0 abs-x/y (word-neg abs-x/y))
            (if y<0 (word-neg abs-x/y) abs-x/y))))))

(defun word-mod (x y)
  "The remainder after signed integer division with truncation towards
zero."
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (let ((abs-x (if x<0 (word-neg x) x))
          (abs-y (if y<0 (word-neg y) y)))
      (let* ((abs-x%y (the word
                           (logand (nth-value 1 (floor abs-x abs-y))
                                   #xFFFFFFFF))))
        (if x<0 (word-neg abs-x%y) abs-x%y)))))

(defun b2i (b)
  (declare (type boolean b))
  (if b 1 0))

(defun word-lt (x y)
  "Signed comparison: is x less than y?"
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (b2i (if x<0
             (if y<0 (< x y) t)
             (if y<0 nil (< x y))))))

(defun word-le (x y)
  "Signed comparison: is x less than or equal to y?"
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (b2i (if x<0
             (if y<0 (<= x y) t)
             (if y<0 nil (<= x y))))))

(defun word-gt (x y)
  "Signed comparison: is x greater than y?"
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (b2i (if x<0
             (if y<0 (> x y) nil)
             (if y<0 t (> x y))))))

(defun word-ge (x y)
  "Signed comparison: is x greater than or equal to y?"
  (declare (type word x))
  (declare (type word y))
  (let ((x<0 (word-signbit-p x))
        (y<0 (word-signbit-p y)))
    (b2i (if x<0
             (if y<0 (>= x y) nil)
             (if y<0 t (>= x y))))))

(defun word-eq (x y)
  "Is x equal to y?"
  (declare (type word x))
  (declare (type word y))
  (b2i (= x y)))

(defun word-ne (x y)
  "Is x not equal to y?"
  (declare (type word x))
  (declare (type word y))
  (b2i (/= x y)))

(defun word-cmp (x)
  "The logical complement."
  (declare (type word x))
  (b2i (= x 0)))

(defun word-and (x y)
  "The logical conjunction."
  (declare (type word x))
  (declare (type word y))
  (b2i (and (/= x 0) (/= y 0))))

(defun word-or (x y)
  "The logical disjunction."
  (declare (type word x))
  (declare (type word y))
  (b2i (or (/= x 0) (/= y 0))))

(defun unop (stack sp operation)
  "Perform a unary operation on the stack."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (declare (type (function (word) word) operation))
  (let ((i (elt sp 0)))
    (unless (<= 1 i)
      (warn "stack underflow")
      (uiop:quit 1))
    (let ((x (elt stack (1- i))))
      (setf (elt stack (1- i)) (funcall operation x)))))

(defun binop (stack sp operation)
  "Perform a binary operation on the stack."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (declare (type (function (word word) word) operation))
  (let ((i (elt sp 0)))
    (unless (<= 2 i)
      (warn "stack underflow")
      (uiop:quit 1))
    (let ((x (elt stack (- i 2)))
          (y (elt stack (1- i))))
      (setf (elt stack (- i 2)) (funcall operation x y)))
    (setf (elt sp 0) (1- i))))

(defun jri (code ip)
  "Jump relative immediate."
  (declare (type executable-memory code))
  (declare (type register ip))
  ;; Big-endian order.
  (let ((j (elt ip 0)))
    (unless (<= (+ j 4) executable-memory-size)
      (warn "address past end of executable memory")
      (uiop:quit 1))
    (let* ((offset (elt code (+ j 3)))
           (offset (dpb (elt code (+ j 2)) (byte 8 8) offset))
           (offset (dpb (elt code (+ j 1)) (byte 8 16) offset))
           (offset (dpb (elt code j) (byte 8 24) offset)))
      (setf (elt ip 0) (word-add j offset)))))

(defun jriz (stack sp code ip)
  "Jump relative immediate, if zero."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (declare (type executable-memory code))
  (declare (type register ip))
  (let ((i (elt sp 0)))
    (unless (<= 1 i)
      (warn "stack underflow")
      (uiop:quit 1))
    (let ((x (elt stack (1- i))))
      (setf (elt sp 0) (1- i))
      (if (= x 0)
          (jri code ip)
          (setf (elt ip 0) (+ (elt ip 0) 4))))))

(defun get-immediate-value (code ip)
  (declare (type executable-memory code))
  (declare (type register ip))
  ;; Big-endian order.
  (let ((j (elt ip 0)))
    (unless (<= (+ j 4) executable-memory-size)
      (warn "address past end of executable memory")
      (uiop:quit 1))
    (let* ((x (elt code (+ j 3)))
           (x (dpb (elt code (+ j 2)) (byte 8 8) x))
           (x (dpb (elt code (+ j 1)) (byte 8 16) x))
           (x (dpb (elt code j) (byte 8 24) x)))
      (setf (elt ip 0) (+ j 4))
      x)))

(defun pushi (stack sp code ip)
  "Push-immediate a value from executable memory onto the stack."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (declare (type executable-memory code))
  (declare (type register ip))
  (let ((i (elt sp 0)))
    (unless (< i stack-memory-size)
      (warn "stack overflow")
      (uiop:quit 1))
    (setf (elt stack i) (get-immediate-value code ip))
    (setf (elt sp 0) (1+ i))))

(defun fetch (stack sp code ip data)
  "Fetch data to the stack, using the storage location given in
executable memory."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (declare (type executable-memory code))
  (declare (type register ip))
  (declare (type data-memory data))
  (let ((i (elt sp 0)))
    (unless (< i stack-memory-size)
      (warn "stack overflow")
      (uiop:quit 1))
    (let* ((k (get-immediate-value code ip))
           (x (elt data k)))
      (setf (elt stack i) x)
      (setf (elt sp 0) (1+ i)))))

(defun pop-one (stack sp)
  (let ((i (elt sp 0)))
    (unless (<= 1 i)
      (warn "stack underflow")
      (uiop:quit 1))
    (let* ((x (elt stack (1- i))))
      (setf (elt sp 0) (1- i))
      x)))

(defun store (stack sp code ip data)
  "Store data from the stack, using the storage location given in
executable memory."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (declare (type executable-memory code))
  (declare (type register ip))
  (declare (type data-memory data))
  (let ((i (elt sp 0)))
    (unless (<= 1 i)
      (warn "stack underflow")
      (uiop:quit 1))
    (let ((k (get-immediate-value code ip))
          (x (pop-one stack sp)))
      (setf (elt data k) x))))

(defun prti (stack sp outf)
  "Print the top value of the stack, as a signed decimal value."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (let* ((n (pop-one stack sp))
         (n<0 (word-signbit-p n)))
    (if n<0
        (format outf "-~D" (word-neg n))
        (format outf "~D" n))))

(defun prtc (stack sp outf)
  "Print the top value of the stack, as a character."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (let* ((c (pop-one stack sp)))
    (format outf "~C" (code-char c))))

(defun prts (stack sp strings outf)
  "Print the string specified by the top of the stack."
  (declare (type stack-memory stack))
  (declare (type register sp))
  (let* ((k (pop-one stack sp))
         (s (elt strings k)))
    (format outf "~A" s)))

(defmacro defun-machine-binop (op)
  (let ((machine-op (read-from-string
                     (concatenate 'string "machine-" (string op))))
        (word-op (read-from-string
                  (concatenate 'string "word-" (string op)))))
    `(defun ,machine-op (mach)
       (declare (type machine mach))
       (binop (machine-stack mach)
              (machine-sp mach)
              #',word-op))))

(defmacro defun-machine-unop (op)
  (let ((machine-op (read-from-string
                     (concatenate 'string "machine-" (string op))))
        (word-op (read-from-string
                  (concatenate 'string "word-" (string op)))))
    `(defun ,machine-op (mach)
       (declare (type machine mach))
       (unop (machine-stack mach)
             (machine-sp mach)
             #',word-op))))

(defun-machine-binop "add")
(defun-machine-binop "sub")
(defun-machine-binop "mul")
(defun-machine-binop "div")
(defun-machine-binop "mod")
(defun-machine-binop "lt")
(defun-machine-binop "gt")
(defun-machine-binop "le")
(defun-machine-binop "ge")
(defun-machine-binop "eq")
(defun-machine-binop "ne")
(defun-machine-binop "and")
(defun-machine-binop "or")

(defun-machine-unop "neg")
(defun machine-not (mach)
  (declare (type machine mach))
  (unop (machine-stack mach)
        (machine-sp mach)
        #'word-cmp))

(defun machine-prtc (mach)
  (declare (type machine mach))
  (prtc (machine-stack mach)
        (machine-sp mach)
        (machine-output mach)))

(defun machine-prti (mach)
  (declare (type machine mach))
  (prti (machine-stack mach)
        (machine-sp mach)
        (machine-output mach)))

(defun machine-prts (mach)
  (declare (type machine mach))
  (prts (machine-stack mach)
        (machine-sp mach)
        (machine-strings mach)
        (machine-output mach)))

(defun machine-fetch (mach)
  (declare (type machine mach))
  (fetch (machine-stack mach)
         (machine-sp mach)
         (machine-code mach)
         (machine-ip mach)
         (machine-data mach)))

(defun machine-store (mach)
  (declare (type machine mach))
  (store (machine-stack mach)
         (machine-sp mach)
         (machine-code mach)
         (machine-ip mach)
         (machine-data mach)))

(defun machine-push (mach)
  (declare (type machine mach))
  (pushi (machine-stack mach)
         (machine-sp mach)
         (machine-code mach)
         (machine-ip mach)))

(defun machine-jmp (mach)
  (declare (type machine mach))
  (jri (machine-code mach)
       (machine-ip mach)))

(defun machine-jz (mach)
  (declare (type machine mach))
  (jriz (machine-stack mach)
        (machine-sp mach)
        (machine-code mach)
        (machine-ip mach)))

(defun get-opcode (mach)
  (declare (type machine mach))
  (let ((code (machine-code mach))
        (ip (machine-ip mach)))
    (let ((j (elt ip 0)))
      (unless (< j executable-memory-size)
        (warn "address past end of executable memory")
        (uiop:quit 1))
      (let ((opcode (elt code j)))
        (setf (elt ip 0) (1+ j))
        opcode))))

(defun run-instruction (mach opcode)
  (declare (type machine mach))
  (declare (type fixnum opcode))
  (let ((op-mod-4 (logand opcode #x3))
        (op-div-4 (ash opcode -2)))
    (trivia:match op-div-4
      (0 (trivia:match op-mod-4
           (1 (machine-add mach))
           (2 (machine-sub mach))
           (3 (machine-mul mach))))
      (1 (trivia:match op-mod-4
           (0 (machine-div mach))
           (1 (machine-mod mach))
           (2 (machine-lt mach))
           (3 (machine-gt mach))))
      (2 (trivia:match op-mod-4
           (0 (machine-le mach))
           (1 (machine-ge mach))
           (2 (machine-eq mach))
           (3 (machine-ne mach))))
      (3 (trivia:match op-mod-4
           (0 (machine-and mach))
           (1 (machine-or mach))
           (2 (machine-neg mach))
           (3 (machine-not mach))))
      (4 (trivia:match op-mod-4
           (0 (machine-prtc mach))
           (1 (machine-prti mach))
           (2 (machine-prts mach))
           (3 (machine-fetch mach))))
      (5 (trivia:match op-mod-4
           (0 (machine-store mach))
           (1 (machine-push mach))
           (2 (machine-jmp mach))
           (3 (machine-jz mach)))))))

(defun run-vm (mach)
  (declare (type machine mach))
  (let ((opcode-for-halt (the fixnum (opcode-from-name "halt")))
        (opcode-for-add (the fixnum (opcode-from-name "add")))
        (opcode-for-jz (the fixnum (opcode-from-name "jz"))))
    (loop for opcode = (the fixnum (get-opcode mach))
          until (= opcode opcode-for-halt)
          do (progn (when (or (< opcode opcode-for-add)
                              (< opcode-for-jz opcode))
                      (warn "unsupported opcode")
                      (uiop:quit 1))
                    (run-instruction mach opcode)))))

(defun usage-error ()
  (princ "Usage: vm [INPUTFILE [OUTPUTFILE]]" *standard-output*)
  (terpri *standard-output*)
  (princ "If either INPUTFILE or OUTPUTFILE is \"-\", the respective"
         *standard-output*)
  (princ " standard I/O is used." *standard-output*)
  (terpri *standard-output*)
  (uiop:quit 1))

(defun get-filenames (argv)
  (trivia:match argv
    ((list) '("-" "-"))
    ((list inpf-filename) `(,inpf-filename "-"))
    ((list inpf-filename outf-filename) `(,inpf-filename
                                          ,outf-filename))
    (_ (usage-error))))

(defun main (&rest argv)
  (let* ((filenames (get-filenames argv))
         (inpf-filename (car filenames))
         (inpf (open-inpf inpf-filename))
         (outf-filename (cadr filenames))
         (outf (open-outf outf-filename))

         (sizes (read-datasize-and-strings-count inpf))
         (datasize (car sizes))
         (strings-count (cadr sizes))
         (strings (read-string-literals inpf strings-count))
         (instructions (read-instructions inpf))
         ;; We shall remain noncommittal about how strings are stored
         ;; on the hypothetical machine.
         (strings (coerce strings 'simple-vector))

         (mach (make-machine :strings strings
                             :output outf)))

    (unless (<= datasize data-memory-size)
      (warn "the VM's data memory size is exceeded")
      (uiop:quit 1))

    (load-executable-memory (machine-code mach) instructions)
    (run-vm mach)

    (unless (string= inpf-filename "-")
      (close inpf))
    (unless (string= outf-filename "-")
      (close outf))

    (uiop:quit 0)))

;;; vim: set ft=lisp lisp:
