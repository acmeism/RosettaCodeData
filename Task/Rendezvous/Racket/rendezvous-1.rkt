#lang racket

;;; Rendezvous primitives implemented in terms of synchronous channels.
(define (send ch msg)
  (define handshake (make-channel))
  (channel-put ch (list msg handshake))
  (channel-get handshake)
  (void))

(define (receive ch action)
  (match-define (list msg handshake) (channel-get ch))
  (action msg)
  (channel-put handshake 'done))

;;; A printer receives a line of text, then
;;;   - prints it                      (still ink left)
;;;   - sends it to the backup printer (if present)
;;;   - raises exception               (if no ink and no backup)
(define (printer id ink backup)
  (define (on-line-received line)
    (cond
      [(and (= ink 0) (not backup)) (raise 'out-of-ink)]
      [(= ink 0)                    (send backup line)]
      [else                         (display (~a id ":"))
                                    (for ([c line]) (display c))
                                    (newline)]))
  (define ch (make-channel))
  (thread
   (λ ()
    (let loop ()
      (receive ch on-line-received)
      (set! ink (max 0 (- ink 1)))
      (loop))))
  ch)

;;; Setup two printers

(define reserve (printer "reserve" 5 #f))
(define main    (printer "main"    5 reserve))

;;; Two stories

(define humpty
  '("Humpty Dumpty sat on a wall."
	"Humpty Dumpty had a great fall."
	"All the king's horses and all the king's men,"
	"Couldn't put Humpty together again."))

(define goose
  '("Old Mother Goose,"
    "When she wanted to wander,"
    "Would ride through the air,"
	"On a very fine gander."
	"Jack's mother came in,"
	"And caught the goose soon,"
	"And mounting its back,"
	"Flew up to the moon."))

;;; Print the stories
(for ([l humpty]) (send main l))
(for ([l goose])  (send main l))
