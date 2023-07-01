(define change '(25 10 5 1))
(define c-1 (list-tail change -1)) ;; pointer to (1)
(ways 100 change)
    → 242

(define change '(100 50 25 10 5 1))
(define c-1 (list-tail change -1))
(for ((i (in-range 0 200001 20000)))
    (writeln i (time (ways i change)) (hash-count Hcoins)))


;; iterate cents = 20000, 40000, ..
;; cents ((time (msec) number-of-ways) number-of-entries-in-h-table

20000      (350 4371565890901)         9398
40000      (245 138204514221801)       18798
60000      (230 1045248220992701)      28198
80000      (255 4395748062203601)      37598
100000     (234 13398445413854501)     46998
120000     (230 33312577651945401)     56398
140000     (292 71959878152476301)     65798
160000     (736 140236576291447201)     75198
180000     (237 252625397444858101)     84598
200000     (240 427707562988709001)     93998

;; One can see that the time is linear, and the h-table size reasonably small

change
    → (100 50 25 10 5 1)
(ways 100000 change)
    → 13398445413854501
