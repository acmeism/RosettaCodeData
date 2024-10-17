(define (char-freq port table)
  (if
   (eof-object? (peek-char port))
   table
   (char-freq port (add-char (read-char port) table))))

(define (add-char char table)
  (cond
   ((null? table) (list (list char 1)))
   ((eq? (caar table) char) (cons (list char (+ (cadar table) 1)) (cdr table)))
   (#t (cons (car table) (add-char char (cdr table))))))

(define (nodeify table)
  (map (lambda (x) (list x '() '())) table))

(define node-freq cadar)

(define (huffman-tree nodes)
  (let ((queue (sort nodes (lambda (x y) (< (node-freq x) (node-freq y))))))
    (if
     (null? (cdr queue))
     (car queue)
     (huffman-tree
      (cons
       (list
        (list 'notleaf (+ (node-freq (car queue)) (node-freq (cadr queue))))
        (car queue)
        (cadr queue))
       (cddr queue))))))

(define (list-encodings tree chars)
  (for-each (lambda (c) (format #t "~a:~a~%" c (encode c tree))) chars))

(define (encode char tree)
  (cond
   ((null? tree) #f)
   ((eq? (caar tree) char) '())
   (#t
    (let ((left (encode char (cadr tree))) (right (encode char (caddr tree))))
      (cond
       ((not (or left right)) #f)
       (left (cons #\1 left))
       (right (cons #\0 right)))))))

(define (decode digits tree)
  (cond
   ((not (eq? (caar tree) 'notleaf)) (caar tree))
   ((eq? (car digits) #\0) (decode (cdr digits) (cadr tree)))
   (#t (decode (cdr digits) (caddr tree)))))

(define input "this is an example for huffman encoding")
(define freq-table (char-freq (open-input-string input) '()))
(define tree (huffman-tree (nodeify freq-table)))
(list-encodings tree (map car freq-table))
