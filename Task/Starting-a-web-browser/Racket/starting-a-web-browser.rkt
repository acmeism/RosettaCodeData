#lang at-exp racket

... same code as "Separate_the_house_number_from_the_street_name" ...

(require net/sendurl scribble/html)

(define (render-table)
  (for/list ([str (in-list (string-split adressen #rx" *\r?\n *"))]
             [i   (in-naturals)])
    (tr bgcolor: (if (even? i) "#fcf" "#cff")
        (td str)
        (map td (cond [(splits-adressen str) => cdr] [else '(??? ???)])))))

@(compose1 send-url/contents xml->string){
  @html{@head{@title{Splitting Results}}
        @body{@h1{Splitting Results}
              @table{@render-table}}}
}
