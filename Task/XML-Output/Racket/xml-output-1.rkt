#lang racket
(require xml)

(define (make-character-xexpr characters remarks)
  `(CharacterRemarks
    ,@(for/list ([character characters]
                [remark remarks])
       `(Character ((name ,character)) ,remark))))

(display-xml/content
 (xexpr->xml
  (make-character-xexpr
   '("April" "Tam O'Shanter" "Emily")
   '("Bubbly: I'm > Tam and <= Emily"
     "Burns: \"When chapman billies leave the street ...\""
     "Short & shrift"))))
