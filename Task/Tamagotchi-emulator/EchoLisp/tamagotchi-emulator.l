(define-constant CYCLE_TIME 30000) ;; 30 sec for tests, may be 4 hours, 1 day ...
(string-delimiter "")
(struct tamagotchi (name age food poop bored))

;; utility : display tamagotchi thoughts : transitive verb + complement
(define (tama-talk tama)
(writeln (string-append
   "😮 : "
   (word-random #:any '( verbe trans inf -vintran)))
   " les "
   (word-random #:any '(nom pluriel))))

;; load tamagotchi from persistent storage into *tama* global
(define (run-tamagotchi)
	(if (null? (local-get '*tama*))
	    (writeln "Please (make-tamagotchi <name>)")
	(begin
	    (make-tamagotchi (tamagotchi-name *tama*) *tama*)
	    (tama-cycle *tama*)
	    (writeln (tama-health *tama*)))))
		
;; make a new tamagotchi
;; or instantiate an existing
;; tama : instance ot tamagotchi structure
(define (make-tamagotchi name (tama null))
(when (null? tama)
		(set! tama (tamagotchi name 0 2 0 0))
		(define-global '*tama* tama)
		(local-put '*tama*))
		
;; define the <name> procedure :
;;  perform user action / save tamagotchi / display status

(define-global name
(lambda (action)
	(define tama (local-get '*tama*))
	[case action
	((feed) (set-tamagotchi-food! tama  (1+  (tamagotchi-food tama))))
	((talk)  (tama-talk tama) (set-tamagotchi-bored! tama (max 0 (1- (tamagotchi-bored tama)))))
	((clean) (set-tamagotchi-poop! tama (max 0 (1- (tamagotchi-poop tama)))))
	((look) #t)
;; debug actions
	((_cycle) (tama-cycle tama))
	((_reset) (set! *tama* null) (local-put '*tama*))
	((_kill) (set-tamagotchi-age! tama 44))
	((_self) (writeln tama))
	(else (writeln "actions: feed/talk/clean/look"))]
	
	(local-put '*tama*)
	(tama-health tama))))
	
;; every n msec : get older / eat food / get bored / poop
(define (tama-cycle tama)
		(when (tama-alive tama)
		(set-tamagotchi-age! tama (1+ (tamagotchi-age tama)))
		(set-tamagotchi-bored! tama (+   (tamagotchi-bored tama) (random 2)))
		(set-tamagotchi-food! tama  (max 0 (-  (tamagotchi-food tama) 2)))
		(set-tamagotchi-poop! tama  (+   (tamagotchi-poop tama) (random 2))))
		(local-put '*tama*))
		
;; compute sickness (too much poop, too much food, too much bored)
(define (tama-sick tama) 	
	 (+ (tamagotchi-poop tama)
	    (tamagotchi-bored tama)
	    (max 0 (- (tamagotchi-age tama) 32)) ;; die at 42
	    (abs (-  (tamagotchi-food tama) 2))))
	
;; alive if sickness <= 10
(define (tama-alive tama)
		(<= (tama-sick tama) 10))
	
;; display num icons from a list
(define (icons list num)
		(for/fold (str "  ") ((i [in-range 0 num] ))
		(string-append str (list-ref list (random (length list))))))
	
;; display boredom/food/poops icons
(define (tama-status tama)
	(if (tama-alive tama)
		(string-append
		" [ "
		(icons '(💤  💭 ❓ ) (tamagotchi-bored tama))
		(icons  '(🍼 🍔 🍟 🍰  🍜 ) (tamagotchi-food tama))
		(icons '(💩) (tamagotchi-poop tama))
		" ]")
	    " R.I.P" ))
	
;; display health status = f(sickness)
(define (tama-health tama)
	(define sick (tama-sick tama))
	;;(writeln 'health:sick°= sick)
	(string-append
	(format "%a (🎂 %d)  " (tamagotchi-name tama)(tamagotchi-age tama))
	(cond
	([<= sick 2]   (icons '(😄  😃  😀 😊  😎️  👍 ) 1 ))  ;; ok <= 2
	([<= sick 4]   (icons '(😪  😥  😰  😓  )  1))
	([<= sick 6]   (icons '(😩  😫 )  1))
	([<= sick 10]  (icons '(😡  😱 ) 1)) ;; very bad
	(else  (icons '(❌  💀  👽  😇 ) 1))) ;; dead
    (tama-status tama)))

;; timer operations
;; run tama-proc = cycle every CYCLE_TIME msec

(define (tama-proc n)
	(define tama (local-get '*tama*))
	(when (!null? tama)
		(tama-cycle tama)
		(writeln (tama-health tama))))
		
;; boot
;; manual boot or use (preferences) function
(every CYCLE_TIME tama-proc)
(run-tamagotchi)

