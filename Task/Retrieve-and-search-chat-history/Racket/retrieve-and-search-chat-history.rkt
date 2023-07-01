#lang racket
(require net/url)
(require racket/date)

;; generate archive url from specified number of days in the past
(define (generate-url days-ago)
  (putenv "TZ" "Europe/Berlin") ; this works for Linux
  (let* [(today (current-date))
         (past (seconds->date (- (date->seconds today) (* days-ago 60 60 24))))
         (date-str (string-append
                    (~r (date-year past) #:min-width 4 #:pad-string "0") ; 4 digit year
                    "-"
                    (~r (date-month past) #:min-width 2 #:pad-string "0") ; 2 digit month
                    "-"
                    (~r (date-day past) #:min-width 2 #:pad-string "0"))) ; 2 digit day
         (url (string-append "http://tclers.tk/conferences/tcl/" date-str ".tcl"))]
    url))

;; retrieve content of url as a list of strings
(define (get-content-of-url url-string)
  (let [(st (open-output-string))]
    (copy-port (get-pure-port (string->url url-string)
                              #:redirections 100)
               st)
    (string-split  (get-output-string st) "\n"))) ; divide on line breaks

;; from a list of strings, return a list of those containing the search string
(define (get-matches lines search-string)
  (define (internal-get-matches lines search-string results)
    (cond
      ((empty? lines) results)
      (else (internal-get-matches (cdr lines)
                                  search-string
                                  (if (string-contains? (car lines) search-string)
                                      (append results (list (car lines)))
                                      results)))))
  (internal-get-matches lines search-string (list)))

;; display last 10 days worth of archives that contain matches to the search string
(define (display-matches-for-last-10-days search-string)
  ;; get archives from 9 days ago until today
  (for/list ([i (range 9 -1 -1)])
    (let* ([url (generate-url i)]
           [matches (get-matches (get-content-of-url url) search-string)])
      (cond [(not (empty? matches))
             (begin
               (display url)(newline)
               (display "------\n")
               (for/list ([line matches]) (display line)(newline))
               (display "------\n"))]))))


;; use the first command line argument as the search string
;; display usage info if no search string is provided
(cond ((= 0 (vector-length (current-command-line-arguments))) (display "USAGE: chat_history <search term>\n"))
      (else (display-matches-for-last-10-days (vector-ref (current-command-line-arguments) 0))))
