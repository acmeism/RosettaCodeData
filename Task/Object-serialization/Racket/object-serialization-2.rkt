#lang racket
;; Object Serialization: Tim Brown, Oct. 2014
(require racket/serialize)

(define (join-person-name-list persons)
  (string-join (map (λ (c) (send c ->string)) persons) ", "))

(define-serializable-class person% object%
  (init-field name [siblings null])
  (define/public (->string #:show (show null))
    (cond
      [(and (member 'siblings show) (not (null? siblings)))
       (format "~a (~a)" name (join-person-name-list siblings))]
      [else name]))
  (super-new))

(define-serializable-class parent% person%
  (init-field [children null])
  (define/override (->string #:show (show null))
    (cond
      [(and (member 'children show) (not (null? children)))
       (format "~a [~a]" (super ->string #:show show) (join-person-name-list children))]
      [else (super ->string #:show show)]))
  (super-new))

;; horribly out of fashion and probaly no longer PC
(define-serializable-class nuclear-family% object%
  (init-field father mother children)
  (define/public (->string)
    (string-append
     (format "~a + ~a -> " (send father ->string) (send mother ->string))
     (format "~a" (join-person-name-list children))))
  (super-new))

;; =| TESTS |=========================================================================================
(define jack (new person% [name "Jack"]))
(define joan (new person% [name "Joan"]))
(set-field! siblings jack (list joan))
(set-field! siblings joan (list jack))
(define the-kids (list jack joan))
(define john (new parent% [name "John"] [children the-kids]))
(define jane (new parent% [name "Jane"] [children the-kids]))

(define the-family
  (new nuclear-family% [father john] [mother jane] [children the-kids]))

(define (duplicate-object-through-file o f-name)
  (with-output-to-file f-name #:exists 'replace (λ () (write (serialize o))))
  (with-input-from-file f-name (λ () (deserialize (read)))))

(define cloned-family (duplicate-object-through-file the-family "objects.dat"))

(printf "The original family:\t~a~%" (send the-family ->string))
(printf "The cloned family:\t~a~%~%" (send cloned-family ->string))
(printf "objects.dat contains ----~%~a~%-------------------~%~%" (file->string "objects.dat"))
(printf "Clones are different?~%")
(define cloned-jack (first (get-field children cloned-family)))
(set-field! name cloned-jack "JACK")
(printf "Jack's  name is:\t~s~%" (get-field name jack))
(printf "Clone's name is:\t~s~%~%" (get-field name cloned-jack))
(printf "Relationships are maintained?~%")
(define cloned-joan (second (get-field children cloned-family)))
(printf "Joan's description with siblings:\t~s~%" (send joan ->string #:show '(siblings)))
(printf "Clone's description with siblings:\t~s~%~%"
        (send cloned-joan ->string #:show '(siblings)))
(printf "After Jack's renaming the cloned family is: ~a~%~%" (send cloned-family ->string))
(printf "Various descriptions of cloned John:~%")
(define cloned-john (get-field father cloned-family))
(printf "Just the name:\t~s~%" (send cloned-john ->string))
(printf "With siblings:\t~s (he hasn't any)~%" (send cloned-john ->string #:show '(siblings)))
(printf "With children:\t~s~%" (send cloned-john ->string #:show '(children)))
(printf "With both:\t~s~%" (send cloned-john ->string #:show '(siblings children)))
