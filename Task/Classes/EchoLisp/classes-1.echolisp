(lib 'gloops) ; load oo library

(define-class Person null (name (age :initform 66)))
(define-method tostring (Person) (lambda (p)  ( format "🚶 %a " p.name)))
(define-method mailto (Person Person) (lambda( p o) (printf "From %a to️  %a : ..." p o)))

;; define a sub-class of Person with same methods
(define-class Writer (Person)  (books))
(define-method tostring (Writer) (lambda (w)( format "🎩 %a" w.name)))
(define-method mailto (Person Writer)
	(lambda (p w) (printf " From %a (age %d). Dear writer of %a ..." p p.age  w.books )))
