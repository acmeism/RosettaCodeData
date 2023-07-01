#lang racket
(require srfi/13)

(define command-table #<<EOS
add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1  Schange  Cinsert 2  Clast 3
compress 4 copy 2 count 3 Coverlay 3 cursor 3  delete 3 Cdelete 2  down 1  duplicate
3 xEdit 1 expand 3 extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
forward 2  get  help 1 hexType 4  input 1 powerInput 3  join 1 split 2 spltJOIN load
locate 1 Clocate 2 lowerCase 3 upperCase 3 Lprefix 2  macro  merge 2 modify 3 move 2
msg  next 1 overlay 1 parse preserve 4 purge 3 put putD query 1 quit  read recover 3
refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4 rgtLEFT right 2 left
2  save  set  shift 2  si  sort  sos  stack 3 status 4 top  transfer 3  type 1  up 1
EOS
  )

(define command/abbr-length-pairs
  (let loop ((cmd-len-list (string-split command-table)) (acc (list)))
    (match cmd-len-list
      ((list) (sort acc < #:key cdr))
      ((list-rest a (app string->number (and ad (not #f))) dd) (loop dd (cons (cons a ad) acc)))
      ((list-rest a d) (loop d (cons (cons a (string-length a)) acc))))))

(define (validate-word w)
  (or (let ((w-len (string-length w)))
        (for/first ((candidate command/abbr-length-pairs)
                    #:when (and (>= w-len (cdr candidate)) (string-prefix-ci? w (car candidate))))
          (string-upcase (car candidate))))
      "*error*"))

(define (validate-string s) (string-join (map validate-word (string-split s))))

(module+ main
  (define (debug-i/o s) (printf "input:  ~s~%output: ~s~%" s (validate-string s)))
  (debug-i/o "")
  (debug-i/o "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin"))

(module+ test
  (require rackunit)
  (check-equal?
   (validate-string "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin")
   "RIGHT REPEAT *error* PUT MOVE RESTORE *error* *error* *error* POWERINPUT")
  (check-equal? (validate-string "") ""))
