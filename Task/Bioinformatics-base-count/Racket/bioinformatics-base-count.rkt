#lang racket

(define (fold-sequence seq kons #:finalise (finalise (λ x (apply values x))) . k0s)
  (define (recur seq . ks)
    (if (null? seq)
      (call-with-values (λ () (apply finalise ks)) (λ vs (apply values vs)))
      (call-with-values (λ () (apply kons (car seq) ks)) (λ ks+ (apply recur (cdr seq) ks+)))))
  (apply recur (if (string? seq) (string->list (regexp-replace* #px"[^ACGT]" seq "")) seq) k0s))

(define (sequence->pretty-printed-string seq)
  (define (fmt idx cs-rev) (format "~a: ~a" (~a idx #:width 3 #:align 'right) (list->string (reverse cs-rev))))
  (fold-sequence
    seq
    (λ (b n start-idx lns-rev cs-rev)
       (if (zero? (modulo n 50))
	 (values (+ n 1) n (if (pair? cs-rev) (cons (fmt start-idx cs-rev) lns-rev) lns-rev) (cons b null))
	 (values (+ n 1) start-idx lns-rev (cons b cs-rev))))
    0 0 null null
    #:finalise (λ (n idx lns-rev cs-rev)
		(string-join (reverse (if (null? cs-rev) lns-rev (cons (fmt idx cs-rev) lns-rev))) "\n"))))

(define (count-bases b as cs gs ts n)
  (values (+ as (if (eq? b #\A) 1 0))
	  (+ cs (if (eq? b #\C) 1 0))
	  (+ gs (if (eq? b #\T) 1 0))
	  (+ ts (if (eq? b #\G) 1 0))
	  (add1 n)))

(define (bioinformatics-Base_count s)
  (define-values (as cs gs ts n) (fold-sequence s count-bases 0 0 0 0 0))
  (printf "SEQUENCE:~%~%~a~%~%" (sequence->pretty-printed-string s))
  (printf "BASE COUNT:~%-----------~%~%~a~%~%"
	  (string-join (map (λ (c n) (format " ~a :~a" c (~a #:width 4 #:align 'right n)))
			    '(A T C G)
			    (list as ts cs gs)) "\n"))
  (newline)
  (printf "TOTAL: ~a~%" n))

(module+
  main
  (define the-string
    #<<EOS
CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATG
CTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTG
AGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGAT
GGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT
CGATTCTGCTTATAACACTATGTTCTTATGAAATGGATGTTCTGAGTTGG
TCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA
TTTAATTTTTCTATATAGCGATCTGTATTTAAGCAATTCATTTAGGTTAT
CGCCGCGATGCTCGGTTCGGACCGCCAAGCATCTGGCTCCACTGCTAGTG
TCCTAAATTTGAATGGCAAACACAAATAAGATTTAGCAATTCGTGTAGAC
GACCGGGGACTTGCATGATGGGAGCAGCTTTGTTAAACTACGAACGTAAT
EOS
)
  (bioinformatics-Base_count the-string))
