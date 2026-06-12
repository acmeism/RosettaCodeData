#lang unstable/2d racket

(define (ask-y/n q)
  (printf "~a [y/n]?" q)
  (define (get-y/n)
    (match (read-line)
      [(? eof-object?) eof]
      [(regexp #rx"^[yY]") #t]
      [(regexp #rx"^[nN]") #f]
      [_ (printf "reply yes or no, please:") (get-y/n)]))
  (get-y/n))

(define (cells->hash grid)
  (for*/hash ((block (in-list grid)) (address (in-list (car block))))
    (values address (match (cdr block)
                      ['(N) #f]
                      ['(Y) #t]
                      ['(X) 'X]
                      [else else]))))

(define (run-decision-table tbl)
  (match-define (list '2ddecision_table col-widths row-heights all-cells ...) tbl)

  ;; after this, the rules without an X are removed
  (define full-cells (filter (match-lambda [(list _ _ _ ...) #t] [_ #f]) all-cells))

  ;; cell addresses are (list column row)
  (match-define
    (list-no-order
     `((,_ ... (1 1) ,_ ...)                           ,caption ...)
     `(((,rules-columns ,_) ...)                        Rules)
     `(((,(app add1 text-columns) ,condition-rows) ...) Conditions)
     `(((,_ ,action-rows) ...)                          Actions)
     remaining-cells ...)
    full-cells)

  (define remaining-cells# (cells->hash remaining-cells))
  (define (cell# c r (dflt #f))
    (hash-ref remaining-cells# (list c r) dflt))

  (define text-column (first text-columns))

  (let question-loop ((remain-conds condition-rows) (remain-acts action-rows))
    (match remain-conds
      [(list) (displayln "I give up... read the manual or something.")]
      [(list conds-h conds-t ...)
       (match (ask-y/n (string-join (map ~a (cell# text-column conds-h)) " "))
         [(? eof-object?) "bye!"]
         [y/n-response
          (define remain-acts-
            (for/list
                ((action remain-acts)
                 #:when (for/first
                            ((rule-c (in-list rules-columns))
                             #:when (eq? (cell# rule-c conds-h) y/n-response) ; matches rule flag
                             #:when (equal? (cell# rule-c action #f) 'X)) ; has an X
                          #t))
              action))
          (match remain-acts-
            [(list) (printf "No more actions... no more suggestions from the rules!~%")]
            [(list only-action) (printf "Suggested action: ~s~%" (cell# text-column only-action))]
            [_ (question-loop conds-t remain-acts-)])])])))

(define printer-troubleshooting-2dtable
  '#2ddecision_table
  ╔═╦════════════╦════════════════════════════════════════════╦═╦═╦═╦═╦═╦═╦═╦═╗
  ║ ║            ║                                            ║ ║ ║ ║ ║ ║ ║ ║ ║
  ╠═╬════════════╩════════════════════════════════════════════╬═╩═╩═╩═╩═╩═╩═╩═╣
  ║ ║ Printer troubleshooter                                  ║ Rules         ║
  ╠═╬════════════╦════════════════════════════════════════════╬═══════╦═══════╣
  ║ ║ Conditions ║ Printer does not print                     ║Y      ║N      ║
  ╠═╣            ╠════════════════════════════════════════════╣   ╔═══╬═══╗   ║
  ║ ║            ║ A red light is flashing                    ║   ║N  ║Y  ║   ║
  ╠═╣            ╠════════════════════════════════════════════╣ ╔═╬═╗ ║ ╔═╬═╗ ║
  ║ ║            ║ Printer is unrecognized                    ║ ║N║Y║ ║ ║N║Y║ ║
  ╠═╬════════════╬════════════════════════════════════════════╬═╩═╬═╬═╩═╩═╩═╩═╣
  ║ ║ Actions    ║ Check the power cable                      ║   ║X║         ║
  ╠═╣            ╠════════════════════════════════════════════╬═╗ ║ ║         ║
  ║ ║            ║ Check the printer-computer cable           ║X║ ║ ║         ║
  ╠═╣            ╠════════════════════════════════════════════╣ ║ ║ ║ ╔═╗ ╔═╗ ║
  ║ ║            ║ Ensure printer software is installed       ║ ║ ║ ║ ║X║ ║X║ ║
  ╠═╣            ╠════════════════════════════════════════════╣ ╚═╬═╝ ║ ╚═╬═╝ ║
  ║ ║            ║ Check/replace ink                          ║   ║   ║   ║   ║
  ╠═╣            ╠════════════════════════════════════════════╬═╗ ║ ╔═╬═══╝   ║
  ║ ║            ║ Check for paper jam                        ║ ║ ║ ║X║       ║
  ╚═╩════════════╩════════════════════════════════════════════╩═╩═╩═╩═╩═══════╝)

(run-decision-table printer-troubleshooting-2dtable)
