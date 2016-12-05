(lib 'hash)
(lib 'amb)

;; return #f or house# for thing/category
;; houses := (0 1 2 3 4)
(define (house-get H  category thing houses)
        (for/or ((i houses)) #:continue (!equal? (hash-ref (vector-ref H i) category) thing)
        i))

 ;; return house # for thing (eg cat) in category (eq animals)
 ;; add thing if not already here
(define-syntax-rule (house-set thing category)
    	(or
    	 (house-get H 'category 'thing houses)
         (dispatch H 'category 'thing context houses )))

;; we know that thing/category is in a given house
(define-syntax-rule (house-force thing category house)
        (dispatch H 'category 'thing context houses  house))

;; return house# or fail if impossible
(define (dispatch H category thing  context houses  (forced #f))
        (define house (or forced  (amb context houses))) ;; get a house number
        (when (hash-ref (vector-ref H house) category) (amb-fail)) ;; fail if occupied
        (hash-set (vector-ref H house) category thing) ;; else remember house contents
        house)

(define (house-next h1 h2)
 	(amb-require (or (= h1 (1+ h2)) (= h1 (1- h2)))))
	
(define (zebra-puzzle context houses  )
    (define H (build-vector 5 make-hash)) ;; house[i] :=  hash(category) -> thing
; In the middle house they drink milk.
    (house-force milk drinks 2)
;The Norwegian lives in the first house.
    (house-force norvegian people 0)
;  The English man lives in the red house.
    (house-force red colors(house-set english people))
; The Swede has a dog.
    (house-force dog animals (house-set swede people))
;  The Dane drinks tea.
    (house-force tea drinks (house-set dane people))
;  The green house is immediately to the left of the white house.
   (amb-require (=   (house-set green colors) (1- (house-set white colors))))
;  They drink coffee in the green house.
    (house-force coffee drinks (house-set green colors))
;  The man who smokes Pall Mall has birds.
    (house-force birds  animals (house-set pallmall smoke))
;  In the yellow house they smoke Dunhill.
    (house-force dunhill smoke (house-set yellow colors))
;  The Norwegian lives next to the blue house.
    (house-next (house-set norvegian people) (house-set blue colors))
;  The man who smokes Blend lives in the house next to the house with cats.
    (house-next (house-set blend smoke) (house-set cats  animals))
; In a house next to the house where they have a horse, they smoke Dunhill.
    (house-next (house-set horse animals) (house-set dunhill smoke))
; The man who smokes Blue Master drinks beer.
    (house-force beer drinks (house-set bluemaster smoke))
; The German smokes Prince.
    (house-force prince smoke (house-set german people))
; They drink water in a house next to the house where they smoke Blend.
    (house-next (house-set water drinks) (house-set blend smoke))

;; Finally .... the zebra 🐴
    (house-set 🐴 animals)

    (for ((i houses))
    (writeln i (hash-values (vector-ref H i))))
    (writeln '----------)

    (amb-fail) ;; will ensure ALL solutions are printed
)
