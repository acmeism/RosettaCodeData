(use gauche.record)

;;  This will let us treat a list as though it is a structure (record).
(define-record-type (employee (pseudo-rtd <list>)) #t #t
  name id salary dept)

(define (get-fields str)
  (map (^x (if (#/^\d/ x) (string->number x) x))
       (string-split str #\,)))

(define (print-record column-widths record)
  (display "  ")
  (print (string-join
    (map
      (^(x width)
        (if (number? x)
          (format "~vD" width x)
          (format "~vA" width x)))
      record
      column-widths))))

(define (get-column-widths records)
  (apply
    map
      (lambda column
        (apply max (map (compose string-length x->string) column)))
      records))

(define records
  (map get-fields
    (string-split
      "Tyler Bennett,E10297,32000,D101
      John Rappl,E21437,47000,D050
      George Woltman,E00127,53500,D101
      Adam Smith,E63535,18000,D202
      Claire Buckman,E39876,27800,D202
      David McClellan,E04242,41500,D101
      Rich Holcomb,E01234,49500,D202
      Nathan Adams,E41298,21900,D050
      Richard Potter,E43128,15900,D101
      David Motsinger,E27002,19250,D202
      Tim Sampair,E03033,27000,D101
      Kim Arlich,E10001,57000,D190
      Timothy Grove,E16398,29900,D190"
      #/\s*\n\s*/)))

(define (top-salaries n records)
  (let ((departments (sort (delete-duplicates (map employee-dept records))))
        (col-widths (get-column-widths records))
        (sorted-by-salary (sort records > employee-salary)))
    (dolist (dept departments)
      (print dept)
      (let1 matches (filter (^x (string=? dept (employee-dept x)))
                            sorted-by-salary)
        (for-each
          (pa$ print-record col-widths)
          (take* matches n))))))
