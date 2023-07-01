(lib 'struct) ;; tables are based upon structures
(lib 'sql)  ;; sql-select function

;; input table
(define emps  (make-table (struct emp (name id salary dept))))
;; output table
(define high  (make-table (struct out (dept name salary))))

;; sort/group procedure
(define (get-high num-records: N into: high)
(sql-select emp.dept emp.name emp.salary
  from emps
  group-by emp.dept
  order-by emp.salary desc limit N into high))
