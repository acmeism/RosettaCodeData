#lang typed/racket
;;;
;;; The Rosetta Code Virtual Machine, in Typed Racket.
;;;
;;; Migrated from the Common Lisp.
;;;

;;; Yes, I could compute how much memory is needed, or I could assume
;;; that the instructions are in address order. However, for *this*
;;; implementation I am going to use a large fixed-size memory and use
;;; the address fields of instructions to place the instructions.
(: executable-memory-size Positive-Fixnum)
(define executable-memory-size 65536)

;;; Similarly, I am going to have fixed size data and stack memory.
(: data-memory-size Positive-Fixnum)
(define data-memory-size 2048)
(: stack-memory-size Positive-Fixnum)
(define stack-memory-size 2048)

;;; And so I am going to have specialized types for the different
;;; kinds of memory the platform contains. Also for its "word" and
;;; register types.
(define-type Word Nonnegative-Fixnum)
(define-type Register (Boxof Word))
(define-type Executable-Memory (Mutable-Vectorof Byte))
(define-type Data-Memory (Mutable-Vectorof Word))
(define-type Stack-Memory (Mutable-Vectorof Word))

(define re-blank-line #px"^\\s*$")
(define re-parse-instr-1 #px"^\\s*(\\d+)\\s*(.*\\S)")
(define re-parse-instr-2 #px"(?i:^(\\S+)\\s*(.*))")
(define re-parse-instr-3 #px"^[[(]?([0-9-]+)")
(define re-header
  #px"(?i:^\\s*Datasize\\s*:\\s*(\\d+)\\s*Strings\\s*:\\s*(\\d+))")
(define re-leading-spaces #px"^\\s*")

(define opcode-names
  '("halt"
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

(: blank-line? (String -> Boolean))
(define (blank-line? s)
  (not (not (regexp-match re-blank-line s))))

(: opcode-from-name (String -> Byte))
(define (opcode-from-name s)
  (let ((i (index-of opcode-names s)))
    (assert i)
    (cast i Byte)))

(: create-executable-memory (-> Executable-Memory))
(define (create-executable-memory)
  (make-vector executable-memory-size (opcode-from-name "halt")))

(: create-data-memory (-> Data-Memory))
(define (create-data-memory)
  (make-vector data-memory-size 0))

(: create-stack-memory (-> Stack-Memory))
(define (create-stack-memory)
  (make-vector stack-memory-size 0))

(: create-register (-> Register))
(define (create-register)
  (box 0))

(struct machine
  ((sp : Register)   ; Stack pointer.
   (ip : Register)   ; Instruction pointer (that is, program counter).
   (code : Executable-Memory)
   (data : Data-Memory)
   (stack : Stack-Memory)
   (strings : (Immutable-Vectorof String))
   (output : Output-Port))
  #:type-name Machine
  #:constructor-name %make-machine)

(: make-machine ((Immutable-Vectorof String) Output-Port -> Machine))
(define (make-machine strings outf)
  (%make-machine (create-register)
                 (create-register)
                 (create-executable-memory)
                 (create-data-memory)
                 (create-stack-memory)
                 strings
                 outf))

(define-type Instruction-Data (List Word Byte (U False Word)))

(: insert-instruction (Executable-Memory Instruction-Data -> Void))
(define (insert-instruction memory instr)
  (void
   (match instr
     ((list address opcode arg)
      (let ((instr-size (if arg 5 1)))
        (unless (<= (+ address instr-size) executable-memory-size)
          (raise-user-error
           "the VM's executable memory size is exceeded"))
        (vector-set! memory address opcode)
        (when arg
          ;; Big-endian order.
          (vector-set! memory (+ address 1)
                       (bitwise-and (arithmetic-shift arg -24) #xFF))
          (vector-set! memory (+ address 2)
                       (bitwise-and (arithmetic-shift arg -16) #xFF))
          (vector-set! memory (+ address 3)
                       (bitwise-and (arithmetic-shift arg -8) #xFF))
          (vector-set! memory (+ address 4)
                       (bitwise-and arg #xFF))))))))

(: load-executable-memory (Executable-Memory
                           (Listof Instruction-Data) ->
                           Void))
(define (load-executable-memory memory instr-lst)
  (let loop ((p instr-lst))
    (if (null? p)
        (void)
        (let ((instr (car p)))
          (insert-instruction memory (car p))
          (loop (cdr p))))))

(: number->word (Number -> Word))
(define (number->word n)
  (cast (bitwise-and (cast n Integer) #xFFFFFFFF) Word))

(: string->word (String -> Word))
(define (string->word s)
  (let ((n (string->number s)))
    (assert (number? n))
    (number->word n)))

(: parse-instruction (String -> (U False Instruction-Data)))
(define (parse-instruction s)
  (and (not (blank-line? s))
       (let* ((strings (cast (regexp-match re-parse-instr-1 s)
                             (Listof String)))
              (address (cast (string->number (second strings))
                             Word))
              (split (cast (regexp-match re-parse-instr-2
                                         (third strings))
                           (Listof String)))
              (opcode-name (string-downcase (second split)))
              (opcode (opcode-from-name opcode-name))
              (arguments (third split))
              (has-arg? (match opcode-name
                          ((or "fetch" "store" "push" "jmp" "jz") #t)
                          (_ #f))))
         (if has-arg?
             (let* ((argstr-lst
                     (cast (regexp-match re-parse-instr-3 arguments)
                           (Listof String)))
                    (argstr (second argstr-lst))
                    (arg (string->word argstr)))
               `(,address ,opcode ,arg))
             `(,address ,opcode #f)))))

(: read-instructions (Input-Port -> (Listof Instruction-Data)))
(define (read-instructions inpf)
  (let loop ((line (read-line inpf))
             (lst (cast '() (Listof Instruction-Data))))
    (if (eof-object? line)
        (reverse lst)
        (let ((instr (parse-instruction line)))
          (loop (read-line inpf)
                (if instr
                    (cons instr lst)
                    lst))))))

(: read-datasize-and-strings-count (Input-Port -> (Values Word Word)))
(define (read-datasize-and-strings-count inpf)
  (let ((line (read-line inpf)))
    (unless (string? line)
      (raise-user-error "empty input"))
    ;; This is a permissive implementation.
    (let* ((strings (cast (regexp-match re-header line)
                          (Listof String)))
           (datasize (string->word (second strings)))
           (strings-count (string->word (third strings))))
      (values datasize strings-count))))

(: parse-string-literal (String -> String))
(define (parse-string-literal s)
  ;; This is a permissive implementation, but only in that it skips
  ;; any leading space. It does not check carefully for outright
  ;; mistakes.
  (let* ((s (regexp-replace re-leading-spaces s ""))
         (quote-mark (string-ref s 0)))
    (let loop ((i 1)
               (lst (cast '() (Listof Char))))
      (if (char=? (string-ref s i) quote-mark)
          (list->string (reverse lst))
          (let ((c (string-ref s i)))
            (if (char=? c #\\)
                (let ((c0 (match (string-ref s (+ i 1))
                            (#\n #\newline)
                            (c1 c1))))
                  (loop (+ i 2) (cons c0 lst)))
                (loop (+ i 1) (cons c lst))))))))

(: read-string-literals (Input-Port Word -> (Listof String)))
(define (read-string-literals inpf strings-count)
  (for/list ((i (in-range strings-count)))
    (let ((line (read-line inpf)))
      (begin (assert (string? line))
             (parse-string-literal line)))))

(: open-inpf (String -> Input-Port))
(define (open-inpf inpf-filename)
  (if (string=? inpf-filename "-")
      (current-input-port)
      (open-input-file inpf-filename)))

(: open-outf (String -> Output-Port))
(define (open-outf outf-filename)
  (if (string=? outf-filename "-")
      (current-output-port)
      (open-output-file outf-filename #:exists 'truncate)))

(: word-signbit? (Word -> Boolean))
(define (word-signbit? x)
  ;; True if and only if the sign bit is set.
  (not (zero? (bitwise-and x #x80000000))))

(: word-add (Word Word -> Word))
(define (word-add x y)
  ;; Addition with overflow freely allowed.
  (cast (bitwise-and (+ x y) #xFFFFFFFF) Word))

(: word-neg (Word -> Word))
(define (word-neg x)
  ;; The two's complement.
  (word-add (cast (bitwise-xor x #xFFFFFFFF) Word) 1))

(: word-sub (Word Word -> Word))
(define (word-sub x y)
  ;; Subtraction with overflow freely allowed.
  (word-add x (word-neg y)))

(: word-mul (Word Word -> Word))
(define (word-mul x y)
  ;; Signed multiplication.
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (let ((abs-x (if x<0 (word-neg x) x))
          (abs-y (if y<0 (word-neg y) y)))
      (let* ((abs-xy (cast (bitwise-and (* abs-x abs-y) #xFFFFFFFF)
                           Word)))
        (if x<0
            (if y<0 abs-xy (word-neg abs-xy))
            (if y<0 (word-neg abs-xy) abs-xy))))))

(: word-div (Word Word -> Word))
(define (word-div x y)
  ;; The quotient after signed integer division with truncation
  ;; towards zero.
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (let ((abs-x (if x<0 (word-neg x) x))
          (abs-y (if y<0 (word-neg y) y)))
      (let* ((abs-x/y (cast (bitwise-and (quotient abs-x abs-y)
                                         #xFFFFFFFF)
                            Word)))
        (if x<0
            (if y<0 abs-x/y (word-neg abs-x/y))
            (if y<0 (word-neg abs-x/y) abs-x/y))))))

(: word-mod (Word Word -> Word))
(define (word-mod x y)
  ;; The remainder after signed integer division with truncation
  ;; towards zero.
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (let ((abs-x (if x<0 (word-neg x) x))
          (abs-y (if y<0 (word-neg y) y)))
      (let* ((abs-x/y (cast (bitwise-and (remainder abs-x abs-y)
                                         #xFFFFFFFF)
                            Word)))
        (if x<0
            (if y<0 abs-x/y (word-neg abs-x/y))
            (if y<0 (word-neg abs-x/y) abs-x/y))))))

(: b2i (Boolean -> (U Zero One)))
(define (b2i b)
  (if b 1 0))

(: word-lt (Word Word -> Word))
(define (word-lt x y)
  ;; Signed comparison: is x less than y?
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (b2i (if x<0
             (if y<0 (< x y) #t)
             (if y<0 #f (< x y))))))

(: word-le (Word Word -> Word))
(define (word-le x y)
  ;; Signed comparison: is x less than or equal to y?
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (b2i (if x<0
             (if y<0 (<= x y) #t)
             (if y<0 #f (<= x y))))))

(: word-gt (Word Word -> Word))
(define (word-gt x y)
  ;; Signed comparison: is x greater than y?
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (b2i (if x<0
             (if y<0 (> x y) #f)
             (if y<0 #t (> x y))))))

(: word-ge (Word Word -> Word))
(define (word-ge x y)
  ;; Signed comparison: is x greater than or equal to y?
  (let ((x<0 (word-signbit? x))
        (y<0 (word-signbit? y)))
    (b2i (if x<0
             (if y<0 (>= x y) #f)
             (if y<0 #t (>= x y))))))

(: word-eq (Word Word -> Word))
(define (word-eq x y)
  ;; Is x equal to y?
  (b2i (= x y)))

(: word-ne (Word Word -> Word))
(define (word-ne x y)
  ;; Is x not equal to y?
  (b2i (not (= x y))))

(: word-cmp (Word -> Word))
(define (word-cmp x)
  ;; The logical complement.
  (b2i (zero? x)))

(: word-and (Word Word -> Word))
(define (word-and x y)
  ;; The logical conjunction.
  (b2i (and (not (zero? x)) (not (zero? y)))))

(: word-or (Word Word -> Word))
(define (word-or x y)
  ;; The logical disjunction.
  (b2i (or (not (zero? x)) (not (zero? y)))))

(: unop (Stack-Memory Register (Word -> Word) -> Void))
(define (unop stack sp operation)
  ;; Perform a unary operation on the stack.
  (let ((i (unbox sp)))
    (unless (<= 1 i)
      (raise-user-error "stack underflow"))
    (let ((x (vector-ref stack (- i 1))))
      ;; Note how, in contrast to Common Lisp, "operation" is not in a
      ;; namespace separate from that of "ordinary" values, such as
      ;; numbers and strings. (Which way is "better" is a matter of
      ;; taste, and probably depends mostly on what "functional"
      ;; language one learnt first. Mine was Caml Light, so I prefer
      ;; the Scheme way. :) )
      (vector-set! stack (- i 1) (operation x)))))

(: binop (Stack-Memory Register (Word Word -> Word) -> Void))
(define (binop stack sp operation)
  ;; Perform a binary operation on the stack.
  (let ((i (unbox sp)))
    (unless (<= 2 i)
      (raise-user-error "stack underflow"))
    (let ((x (vector-ref stack (- i 2)))
          (y (vector-ref stack (- i 1))))
      (vector-set! stack (- i 2) (operation x y)))
    (set-box! sp (cast (- i 1) Word))))

(: jri (Executable-Memory Register -> Void))
(define (jri code ip)
  ;; Jump relative immediate.
  (let ((j (unbox ip)))
    (unless (<= (+ j 4) executable-memory-size)
      (raise-user-error "address past end of executable memory"))
    ;; Big-endian order.
    (let* ((offset (vector-ref code (+ j 3)))
           (offset (bitwise-ior
                    (arithmetic-shift (vector-ref code (+ j 2)) 8)
                    offset))
           (offset (bitwise-ior
                    (arithmetic-shift (vector-ref code (+ j 1)) 16)
                    offset))
           (offset (bitwise-ior
                    (arithmetic-shift (vector-ref code j) 24)
                    offset)))
      (set-box! ip (word-add j (cast offset Word))))))

(: jriz (Stack-Memory Register Executable-Memory Register -> Void))
(define (jriz stack sp code ip)
  ;; Jump relative immediate, if zero.
  (let ((i (unbox sp)))
    (unless (<= 1 i)
      (raise-user-error "stack underflow"))
    (let ((x (vector-ref stack (- i 1))))
      (set-box! sp (- i 1))
      (if (zero? x)
          (jri code ip)
          (let ((j (unbox ip)))
            (set-box! ip (cast (+ j 4) Word)))))))

(: get-immediate-value (Executable-Memory Register -> Word))
(define (get-immediate-value code ip)
  (let ((j (unbox ip)))
    (unless (<= (+ j 4) executable-memory-size)
      (raise-user-error "address past end of executable memory"))
    ;; Big-endian order.
    (let* ((x (vector-ref code (+ j 3)))
           (x (bitwise-ior
               (arithmetic-shift (vector-ref code (+ j 2)) 8)
               x))
           (x (bitwise-ior
               (arithmetic-shift (vector-ref code (+ j 1)) 16)
               x))
           (x (bitwise-ior
               (arithmetic-shift (vector-ref code j) 24)
               x)))
      (set-box! ip (cast (+ j 4) Word))
      (cast x Word))))

(: pushi (Stack-Memory Register Executable-Memory Register -> Void))
(define (pushi stack sp code ip)
  ;; Push-immediate a value from executable memory onto the stack.
  (let ((i (unbox sp)))
    (unless (< i stack-memory-size)
      (raise-user-error "stack overflow"))
    (vector-set! stack i (get-immediate-value code ip))
    (set-box! sp (cast (+ i 1) Word))))

(: fetch (Stack-Memory
          Register Executable-Memory Register
          Data-Memory -> Void))
(define (fetch stack sp code ip data)
  ;; Fetch data to the stack, using the storage location given in
  ;; executable memory.
  (let ((i (unbox sp)))
    (unless (< i stack-memory-size)
      (raise-user-error "stack overflow"))
    (let* ((k (get-immediate-value code ip))
           (x (vector-ref data k)))
      (vector-set! stack i x)
      (set-box! sp (cast (+ i 1) Word)))))

(: pop-one (Stack-Memory Register -> Word))
(define (pop-one stack sp)
  (let ((i (unbox sp)))
    (unless (<= 1 i)
      (raise-user-error "stack underflow"))
    (let* ((x (vector-ref stack (- i 1))))
      (set-box! sp (- i 1))
      x)))

(: store (Stack-Memory
          Register Executable-Memory Register
          Data-Memory -> Void))
(define (store stack sp code ip data)
  ;; Store data from the stack, using the storage location given in
  ;; executable memory.
  (let ((i (unbox sp)))
    (unless (<= 1 i)
      (raise-user-error "stack underflow"))
    (let ((k (get-immediate-value code ip))
          (x (pop-one stack sp)))
      (vector-set! data k x))))

(: prti (Stack-Memory Register Output-Port -> Void))
(define (prti stack sp outf)
  ;; Print the top value of the stack, as a signed decimal value.
  (let* ((n (pop-one stack sp))
         (n<0 (word-signbit? n)))
    (if n<0
        (begin (display "-" outf)
               (display (word-neg n) outf))
        (display n outf))))

(: prtc (Stack-Memory Register Output-Port -> Void))
(define (prtc stack sp outf)
  ;; Print the top value of the stack, as a character.
  (let ((c (pop-one stack sp)))
    (display (integer->char c) outf)))

(: prts (Stack-Memory
         Register (Immutable-Vectorof String) Output-Port -> Void))
(define (prts stack sp strings outf)
  ;; Print the string specified by the top of the stack.
  (let* ((k (pop-one stack sp))
         (s (vector-ref strings k)))
    (display s outf)))

;;
;; I have written macros in the standard R6RS fashion, with a lambda
;; and syntax-case, so the examples may be widely illustrative. Racket
;; supports this style, despite (purposely) not adhering to any Scheme
;; standard.
;;
;; Some Schemes that do not provide syntax-case (CHICKEN, for
;; instance) provide alternatives that may be quite different.
;;
;; R5RS and R7RS require only syntax-rules, which cannot do what we
;; are doing here. (What we are doing is similar to using ## in a
;; modern C macro, except that the pieces are not merely raw text, and
;; they must be properly typed at every stage.)
;;
(define-syntax define-machine-binop
  (lambda (stx)
    (syntax-case stx ()
      ((_ op)
       (let* ((op^ (syntax->datum #'op))
              (machine-op (string-append "machine-" op^))
              (machine-op (string->symbol machine-op))
              (machine-op (datum->syntax stx machine-op))
              (word-op (string-append "word-" op^))
              (word-op (string->symbol word-op))
              (word-op (datum->syntax stx word-op)))
         #`(begin
             (: #,machine-op (Machine -> Void))
             (define (#,machine-op mach)
               (binop (machine-stack mach)
                      (machine-sp mach)
                      #,word-op))))))))

(define-syntax define-machine-unop
  (lambda (stx)
    (syntax-case stx ()
      ((_ op)
       (let* ((op^ (syntax->datum #'op))
              (machine-op (string-append "machine-" op^))
              (machine-op (string->symbol machine-op))
              (machine-op (datum->syntax stx machine-op))
              (word-op (string-append "word-" op^))
              (word-op (string->symbol word-op))
              (word-op (datum->syntax stx word-op)))
         #`(begin
             (: #,machine-op (Machine -> Void))
             (define (#,machine-op mach)
               (unop (machine-stack mach)
                     (machine-sp mach)
                     #,word-op))))))))

(define-machine-binop "add")
(define-machine-binop "sub")
(define-machine-binop "mul")
(define-machine-binop "div")
(define-machine-binop "mod")
(define-machine-binop "lt")
(define-machine-binop "gt")
(define-machine-binop "le")
(define-machine-binop "ge")
(define-machine-binop "eq")
(define-machine-binop "ne")
(define-machine-binop "and")
(define-machine-binop "or")

(define-machine-unop "neg")

(: machine-not (Machine -> Void))
(define (machine-not mach)
  (unop (machine-stack mach)
        (machine-sp mach)
        word-cmp))

(: machine-prtc (Machine -> Void))
(define (machine-prtc mach)
  (prtc (machine-stack mach)
        (machine-sp mach)
        (machine-output mach)))

(: machine-prti (Machine -> Void))
(define (machine-prti mach)
  (prti (machine-stack mach)
        (machine-sp mach)
        (machine-output mach)))

(: machine-prts (Machine -> Void))
(define (machine-prts mach)
  (prts (machine-stack mach)
        (machine-sp mach)
        (machine-strings mach)
        (machine-output mach)))

(: machine-fetch (Machine -> Void))
(define (machine-fetch mach)
  (fetch (machine-stack mach)
         (machine-sp mach)
         (machine-code mach)
         (machine-ip mach)
         (machine-data mach)))

(: machine-store (Machine -> Void))
(define (machine-store mach)
  (store (machine-stack mach)
         (machine-sp mach)
         (machine-code mach)
         (machine-ip mach)
         (machine-data mach)))

(: machine-push (Machine -> Void))
(define (machine-push mach)
  (pushi (machine-stack mach)
         (machine-sp mach)
         (machine-code mach)
         (machine-ip mach)))

(: machine-jmp (Machine -> Void))
(define (machine-jmp mach)
  (jri (machine-code mach)
       (machine-ip mach)))

(: machine-jz (Machine -> Void))
(define (machine-jz mach)
  (jriz (machine-stack mach)
        (machine-sp mach)
        (machine-code mach)
        (machine-ip mach)))

(: get-opcode (Machine -> Byte))
(define (get-opcode mach)
  (let ((code (machine-code mach))
        (ip (machine-ip mach)))
    (let ((j (unbox ip)))
      (unless (< j executable-memory-size)
        (raise-user-error "address past end of executable memory"))
      (let ((opcode (vector-ref code j)))
        (set-box! ip (cast (+ j 1) Word))
        opcode))))

(: run-instruction (Machine Byte -> Void))
(define (run-instruction mach opcode)
  (let ((op-mod-4 (bitwise-and opcode #x3))
        (op-div-4 (arithmetic-shift opcode -2)))
    (match op-div-4
      (0 (match op-mod-4
           (1 (machine-add mach))
           (2 (machine-sub mach))
           (3 (machine-mul mach))))
      (1 (match op-mod-4
           (0 (machine-div mach))
           (1 (machine-mod mach))
           (2 (machine-lt mach))
           (3 (machine-gt mach))))
      (2 (match op-mod-4
           (0 (machine-le mach))
           (1 (machine-ge mach))
           (2 (machine-eq mach))
           (3 (machine-ne mach))))
      (3 (match op-mod-4
           (0 (machine-and mach))
           (1 (machine-or mach))
           (2 (machine-neg mach))
           (3 (machine-not mach))))
      (4 (match op-mod-4
           (0 (machine-prtc mach))
           (1 (machine-prti mach))
           (2 (machine-prts mach))
           (3 (machine-fetch mach))))
      (5 (match op-mod-4
           (0 (machine-store mach))
           (1 (machine-push mach))
           (2 (machine-jmp mach))
           (3 (machine-jz mach)))))))

(: run-vm (Machine -> Void))
(define (run-vm mach)
  (let ((opcode-for-halt (cast (opcode-from-name "halt") Byte))
        (opcode-for-add (cast (opcode-from-name "add") Byte))
        (opcode-for-jz (cast (opcode-from-name "jz") Byte)))
    (let loop ((opcode (get-opcode mach)))
      (unless (= opcode opcode-for-halt)
        (begin
          (when (or (< opcode opcode-for-add)
                    (< opcode-for-jz opcode))
            (raise-user-error "unsupported opcode"))
          (run-instruction mach opcode)
          (loop (get-opcode mach)))))))

(define (usage-error)
  (display "Usage: vm [INPUTFILE [OUTPUTFILE]]" (current-error-port))
  (newline (current-error-port))
  (display "If either INPUTFILE or OUTPUTFILE is \"-\", the respective"
           (current-error-port))
  (display " standard I/O is used." (current-error-port))
  (newline (current-error-port))
  (exit 1))

(: get-filenames (-> (Values String String)))
(define (get-filenames)
  (match (current-command-line-arguments)
    ((vector) (values "-" "-"))
    ((vector inpf-filename)
     (values (cast inpf-filename String) "-"))
    ((vector inpf-filename outf-filename)
     (values (cast inpf-filename String)
             (cast outf-filename String)))
    (_ (usage-error)
       (values "" ""))))

(let-values (((inpf-filename outf-filename) (get-filenames)))
  (let* ((inpf (open-inpf inpf-filename))
         (outf (open-outf outf-filename)))
    (let-values (((datasize strings-count)
                  (read-datasize-and-strings-count inpf)))
      (let* ((strings
              (vector->immutable-vector
               (list->vector
                (read-string-literals inpf strings-count))))
             (instructions (read-instructions inpf))

             (mach (make-machine strings outf)))

        (unless (<= datasize data-memory-size)
          (raise-user-error
           "the VM's data memory size is exceeded"))

        (load-executable-memory (machine-code mach) instructions)
        (run-vm mach)

        (unless (string=? inpf-filename "-")
          (close-input-port inpf))
        (unless (string=? outf-filename "-")
          (close-output-port outf))

        (exit 0)))))
