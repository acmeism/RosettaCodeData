#lang at-exp racket/base

(require scribble/text)

(define excited "!!!")
(define (shout . text) @list{>>> @text <<<})

(output
 @list{Blah blah blah
         with indentation intact
           but respecting the indentation of
           the whole code
         and "free" \punctuations\
         and even string interpolation-like @excited
           but really @shout{any code}

       })
