; file:   abstract.lsp
; url:    http://rosettacode.org/wiki/Abstract_type
; author: oofoe 2012-01-28

; Abstract Shape Class

(new Class 'Shape)     ; Derive new class.

(define (Shape:Shape   ; Shape constructor.
         (pen "X"))    ; Default value.
  (list (context)      ; Assemble data packet.
        (list 'pen pen)
        (list 'size (args))))

(define (Shape:line x) ; Print out row with 'pen' character.
  (dotimes (i x)
    (print (lookup 'pen (self))))
  (println))

(define (Shape:draw))  ; Placeholder, does nothing.

; Derived Objects

(new Shape 'Box)

(define (Box:draw)     ; Override base draw method.
  (let ((s (lookup 'size (self))))
    (dotimes (i (s 0)) (:line (self) (s 0)))))

(new Shape 'Rectangle)

(define (Rectangle:draw)
  (let ((size (lookup 'size (self))))
    (dotimes (i (size 1)) (:line (self) (size 0)))))

; Demonstration

(:draw (Shape))        ; Nothing happens.

(println "A box:")
(:draw (Box "O" 5))    ; Create Box object and call draw method.

(println "\nA rectangle:")
(:draw (Rectangle "R" 32 4))

(exit)
