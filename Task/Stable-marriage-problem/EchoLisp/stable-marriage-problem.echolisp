(lib 'hash)
;; input data
(define M-RANKS
'(( abe abi eve cath ivy jan dee fay bea hope gay)
(  bob cath hope abi dee eve fay bea jan ivy gay)
(  col hope eve abi dee bea fay ivy gay cath jan)
(  dan ivy fay dee gay hope eve jan bea cath abi)
(   ed jan dee bea cath fay eve abi ivy hope gay)
( fred bea abi dee gay eve ivy cath jan hope fay)
(  gav gay eve ivy bea cath abi dee hope jan fay)
(  hal abi eve hope fay ivy cath jan bea gay dee)
(  ian hope cath dee gay bea abi fay ivy jan eve)
(  jon abi fay jan gay eve bea dee cath ivy hope)))

(define W-RANKS
'((  abi bob fred jon gav ian abe dan ed col hal)
(  bea bob abe col fred gav dan ian ed jon hal)
( cath fred bob ed gav hal col ian abe dan jon)
(  dee fred jon col abe ian hal gav dan bob ed)
(  eve jon hal fred dan abe gav col ed ian bob)
(  fay bob abe ed ian jon dan fred gav col hal)
(  gay jon gav hal fred bob abe col ed dan ian)
( hope gav jon bob abe ian dan hal ed col fred)
(  ivy ian col hal gav fred bob abe ed jon dan)
(  jan ed hal gav abe bob jon col ian fred dan)))

;; build preferences hash
(define (set-prefs ranks  prefs)
    (for/list ((r ranks))
        (hash-set prefs (first r) (rest r))
        (first r)))

(define (engage  m w)    (hash-set ENGAGED m w) (hash-set ENGAGED w m) (writeln  m w '👫 ))
(define (disengage  m w) (hash-remove! ENGAGED m ) (hash-remove! ENGAGED w) (writeln '💔 m w))
(define (engaged x)      (hash-ref ENGAGED x))
(define (free? x)        (not (engaged x)))
(define (free-man men)   (for ((man men)) #:break (free? man) => man  #f))


(define (prefers? prefs x a b) (member b  (member a (hash-ref prefs x))))
;; get first choice and remove it from prefs list
(define (first-choice prefs m)
    (define w (first (hash-ref prefs m)))
    (hash-set prefs m (rest (hash-ref prefs m)))
    w)

;; sets ENGAGED couples
;;  https//en.wikipedia.org/wiki/Stable_marriage_problem

(define (stableMatching  (prefs (make-hash)) (m) (w))
(define-global 'ENGAGED (make-hash))
  (define men   (set-prefs  M-RANKS prefs))
  (define women (set-prefs  W-RANKS prefs))
    (while (setv! m (free-man men))
        (set! w (first-choice prefs m))
        (if (free? w)
            (engage m w)
            (let [(dumped (engaged w))]
            (when (prefers? prefs w m dumped)
                (disengage w dumped)
                (engage w m)))))
 (hash->list ENGAGED))

;; input : ENGAGED couples
(define (checkStable (prefs (make-hash)))
  (define men   (set-prefs  M-RANKS  prefs))
  (define women (set-prefs  W-RANKS  prefs))
	(for* [(man men) (woman women)]
	#:continue (equal? woman (engaged man))
			(when (and
					(prefers? prefs man woman (engaged man))
					(prefers? prefs woman man (engaged woman)))
					(error 'not-stable (list man woman)))))
		
