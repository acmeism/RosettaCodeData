#lang at-exp racket

(define (line . xs) (for-each display xs) (newline))

(let loop ([animals
            '([fly #f]
              [spider "That wriggled and wiggled and tiggled inside her"]
              [bird   "How absurd to swallow a bird"]
              [cat    "Fancy that to swallow a cat"]
              [dog    "What a hog, to swallow a dog"]
              [cow    "I don't know how she swallowed a cow"]
              [horse  "She's dead, of course"])]
           [seen '()])
  (when (pair? animals)
    (match animals
      [(list (list animal desc) more ...)
       @line{There was an old lady that swallowed a @animal,}
       (when desc @line{@|desc|.})
       (when (pair? more)
         (for ([this (cons animal seen)] [that seen])
           @line{She swallowed the @this to catch the @that,})
         @line{I don't know why she swallowed a fly - perhaps she'll die!}
         @line{}
         (loop more (cons animal seen)))])))
